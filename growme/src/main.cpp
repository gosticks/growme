#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <EEPROM.h>
#include <WiFi.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

#include "A4988.h"
#include "MotorControl.hpp"
#include "message.pb.h"
#include "pb_decode.h"
#include "pb_encode.h"
// #include "BluetoothCore.hpp"
// #include "BluetoothSerial.h"
#include "sdkconfig.h"

#define UP_BTN_PIN 27
#define DOWN_BTN_PIN 13
#define M_ENABLE_PIN 5

// define event bits for movement of individual motors
#define DIR_REVERSE_BIT (1UL << 0UL)
#define M1_BIT (1UL << 2UL)
#define M2_BIT (1UL << 3UL)
#define M3_BIT (1UL << 4UL)
#define M4_BIT (1UL << 5UL)
#define M5_BIT (1UL << 6UL)
#define M6_BIT (1UL << 7UL)

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

int runningMotors = 0;
static SemaphoreHandle_t bin_sem;

MotorControl *motors[] = {
	new MotorControl(0, 22, 23),
	new MotorControl(1, 18, 19),
	new MotorControl(2, 16, 17),
	new MotorControl(3, 32, 33),
	new MotorControl(4, 25, 26),
	new MotorControl(5, 14, 12),
};

// BLE characteristic IDs for each motor
char *motorControlCharacteristicUUIDs[] = {
	"68023a4e-e253-46e4-a439-f716b3702ae1",
	"a9102165-7b40-4cce-9008-f4af28b5ac5e",
	"4e9cad83-71d8-40c1-8876-53c1cd5fe27e",
	"e0b49f4b-d7b0-4336-8562-41a16e16e8e6",
	"5f01e609-182f-45fe-aa23-45c12b82e2df",
	"09da8768-b6ba-4b4e-b91f-65d624581d48",
};

// BLE characteristic IDs for each motor
char *motorInfoCharacteristicUUID = "9c05490f-cc74-4fd2-8d16-fb228e3f2270";

// motor movement direction
// -1 = counter clockwise
// 0  = nothing
// 1  = clockwise
int direction = 0;

// TODO: for now use simple arduino based
// task structure adjust as needed afterwards
void motorTask(void *pvParameter) {
	MotorControl *m = (MotorControl *)pvParameter;

	const char *tag = "MotorLoop";

	long ongoingStepTarget = 0;

	// configure motor
	m->stepper->begin(120, 1);

	// track current movement of motor
	uint motorWaitTimeMicros = 0;

	// time for RTOS to use when motor is not spinning
	const TickType_t noActionIdleTime = pdMS_TO_TICKS(100);

	// pick large angle to rotate, such that motor will not stop between loop iterations
	// and RTOS has time to do other things
	int rotationAngle = 100 * 360;

	// add a delay for the MCU to apply setup
	delay(100);

	while (1) {
		// start spinning motor if:
		// - button pressed
		// - no spin command was already started
		if (direction != 0) {
			xSemaphoreTake(bin_sem, portMAX_DELAY);
			if (runningMotors == 0) {
				digitalWrite(M_ENABLE_PIN, LOW);
			}
			runningMotors++;
			xSemaphoreGive(bin_sem);

			m->stepper->startRotate(direction * rotationAngle);

			while (direction != 0) {
				// motor control loop - send pulse and return how long to wait until next pulse
				motorWaitTimeMicros = m->stepper->nextAction();
				if (motorWaitTimeMicros <= 0) {
					// reset execution task
					break;
				} else if (motorWaitTimeMicros >= 50) {
					vTaskDelay(pdMS_TO_TICKS(motorWaitTimeMicros / 1000));
				} else {
					// give tiny amount for RTOS scheduling
					vTaskDelay(20);
				}
			}
			m->stepper->stop();

			xSemaphoreTake(bin_sem, portMAX_DELAY);
			runningMotors--;
			if (runningMotors == 0) {
				digitalWrite(M_ENABLE_PIN, HIGH);
			}
			xSemaphoreGive(bin_sem);
		}

		// target based motor handling
		ongoingStepTarget = m->stepTarget;
		long diff = ongoingStepTarget - m->currentPosition;
		if (diff != 0) {
			ESP_LOGI(tag, "positional diff %ld", diff);
			// NOTE: maybe adjust speed here
			m->stepper->startMove(diff);

			xSemaphoreTake(bin_sem, portMAX_DELAY);
			if (runningMotors == 0) {
				digitalWrite(M_ENABLE_PIN, LOW);
			}
			runningMotors++;
			xSemaphoreGive(bin_sem);

			while (true) {
				// motor control loop - send pulse and return how long to wait until next pulse
				motorWaitTimeMicros = m->stepper->nextAction();
				if (motorWaitTimeMicros <= 0) {
					ESP_LOGI(tag, "move completed");
					// reset execution task
					break;
				} else if (motorWaitTimeMicros >= 50) {
					vTaskDelay(pdMS_TO_TICKS(motorWaitTimeMicros / 1000));
				} else {
					// give tiny amount for RTOS scheduling
					vTaskDelay(20);
				}
			}
			m->updateCurrentPosition(ongoingStepTarget);
			xSemaphoreTake(bin_sem, portMAX_DELAY);
			runningMotors--;
			if (runningMotors == 0) {
				digitalWrite(M_ENABLE_PIN, HIGH);
			}
			xSemaphoreGive(bin_sem);
		}

		vTaskDelay(noActionIdleTime);
	}
};

void controlTask(void *pvParameter) {
	const TickType_t loopDelay = pdMS_TO_TICKS(50);
	// configure button
	pinMode(UP_BTN_PIN, INPUT);

	// MoveMotorCommand init_cmd = MoveMotorCommand_init_zero;
	// pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
	// if (!pb_encode(&stream, MoveMotorCommand_fields, &init_cmd)) {
	// 	Serial.println("added initial value to BLE channel");
	// }

	while (1) {
		// parse movement direction
		if (digitalRead(UP_BTN_PIN) == HIGH) {
			direction = 1;
			ESP_LOGI("MAIN", "down");
		} else if (digitalRead(DOWN_BTN_PIN) == HIGH) {
			direction = -1;
			ESP_LOGI("MAIN", "up");
		} else {
			direction = 0;
		}

		vTaskDelay(loopDelay);
	}
}

bool deviceConnected = false;

class CustomBLEServerCallback : public BLEServerCallbacks {
	void onConnect(BLEServer *pServer) {
		deviceConnected = true;
		ESP_LOGI("MAIN", "connnected to remote");
	};
	void onDisconnect(BLEServer *pServer) {
		deviceConnected = false;
		ESP_LOGI("MAIN", "disconnected from remote");

		// restart advertising after connection loss
		BLEDevice::startAdvertising();
	}
};

extern "C" void app_main() {
	// bootstrap bluetooth controller
	// if (!BluetoothCore::setup()) {
	// 	ESP_LOGI("MAIN", "BT setup failed");
	// }

	// initialize arduino library before we start the tasks
	initArduino();

	// Create mutexes and semaphores before starting tasks
	bin_sem = xSemaphoreCreateBinary();

	pinMode(M_ENABLE_PIN, OUTPUT);
	digitalWrite(M_ENABLE_PIN, HIGH);

	BLEDevice::init("GrowMe-beta-1");
	BLEServer *pServer = BLEDevice::createServer();
	BLEService *pService = pServer->createService(SERVICE_UUID);

	// create motor characteristics
	for (int i = 0; i < sizeof(motors) / sizeof(motors[0]); i++) {
		MotorControl *m = motors[i];
		BLECharacteristic *ctrl = pService->createCharacteristic(
			motorControlCharacteristicUUIDs[i],
			BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

		// register characteristic and callback methods
		m->addControlCharacteristic(ctrl);
	}

	// create single state characteristic
	BLECharacteristic *info = pService->createCharacteristic(motorInfoCharacteristicUUID,
															 BLECharacteristic::PROPERTY_READ);
	info->setCallbacks(new CustomBLEMotorInfoCallback(motors));

	pService->start();
	BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
	pAdvertising->addServiceUUID(SERVICE_UUID);
	pAdvertising->setScanResponse(true);
	pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
	pAdvertising->setMinPreferred(0x12);
	BLEDevice::startAdvertising();

	pServer->setCallbacks(new CustomBLEServerCallback());

	// Setup on device memory
	// one long 64bit state per motor
	EEPROM.begin(8 * 6);

	// xTaskCreate(&arduinoTask, "arduino_task", 8192, NULL, 5, NULL);
	xTaskCreate(&controlTask, "control_task", 4096, NULL, 3, NULL);

	xTaskCreate(&motorTask, "motor_1_task", 4096, (void *)motors[0], 2, NULL);
	xTaskCreate(&motorTask, "motor_2_task", 4096, (void *)motors[1], 2, NULL);
	xTaskCreate(&motorTask, "motor_3_task", 4096, (void *)motors[2], 2, NULL);
	xTaskCreate(&motorTask, "motor_4_task", 4096, (void *)motors[3], 2, NULL);
	xTaskCreate(&motorTask, "motor_5_task", 4096, (void *)motors[4], 2, NULL);
	xTaskCreate(&motorTask, "motor_6_task", 4096, (void *)motors[5], 2, NULL);
}
