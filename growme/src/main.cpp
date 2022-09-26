#include <Arduino.h>
#include <WiFi.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <stdio.h>

#include "A4988.h"
#include "sdkconfig.h"

#define UP_BTN_PIN 27
#define DOWN_BTN_PIN 13

// using a 200-step motor (most common)
#define MOTOR_STEPS 200

// define event bits for movement of individual motors
#define DIR_REVERSE_BIT (1UL << 0UL)
#define M1_BIT (1UL << 2UL)
#define M2_BIT (1UL << 3UL)
#define M3_BIT (1UL << 4UL)
#define M4_BIT (1UL << 5UL)
#define M5_BIT (1UL << 6UL)
#define M6_BIT (1UL << 7UL)

// setup motors
A4988 stepper1(MOTOR_STEPS, 22, 23);
A4988 stepper2(MOTOR_STEPS, 18, 19);
A4988 stepper3(MOTOR_STEPS, 16, 17);
A4988 stepper4(MOTOR_STEPS, 32, 33);
A4988 stepper5(MOTOR_STEPS, 25, 26);
A4988 stepper6(MOTOR_STEPS, 14, 12);

//  declare a event grounp handler variable
EventGroupHandle_t xMotorEventGroup;
// motor movement direction
// -1 = counter clockwise
// 0  = nothing
// 1  = clockwise
int direction = 0;

// TODO: for now use simple arduino based
// task structure adjust as needed afterwards
void motorTask(void *pvParameter) {
	A4988 stepper = *(A4988 *)pvParameter;

	// configure motor
	stepper.begin(120, 1);

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
		if (direction == 0) {
			stepper.stop();
		} else {
			stepper.startRotate(direction * rotationAngle);
		}

		// motor control loop - send pulse and return how long to wait until next pulse
		motorWaitTimeMicros = stepper.nextAction();
		if (motorWaitTimeMicros <= 0) {
			vTaskDelay(noActionIdleTime);
		} else if (motorWaitTimeMicros >= 50) {
			vTaskDelay(pdMS_TO_TICKS(motorWaitTimeMicros / 1000));
		} else {
			// give tiny amount for RTOS scheduling
			vTaskDelay(20);
		}
	}
}

void controlTask(void *pvParameter) {
	const TickType_t loopDelay = pdMS_TO_TICKS(50);

	// configure button
	pinMode(UP_BTN_PIN, INPUT);
	pinMode(DOWN_BTN_PIN, INPUT);

	while (1) {
		// parse movement direction
		if (digitalRead(UP_BTN_PIN) == HIGH) {
			direction = 1;
		} else if (digitalRead(DOWN_BTN_PIN) == HIGH) {
			direction = -1;
		} else {
			direction = 0;
		}

		vTaskDelay(loopDelay);
	}
}

extern "C" void app_main() {
	// initialize arduino library before we start the tasks
	initArduino();

	// setup serial COMs
	Serial.begin(115200);
	// bootstrap bluetooth controller
	Bluetooth

		// setup event group
		xMotorEventGroup = xEventGroupCreate();

	// xTaskCreate(&arduinoTask, "arduino_task", 8192, NULL, 5, NULL);
	xTaskCreate(&controlTask, "control_task", 8192, NULL, 3, NULL);

	xTaskCreate(&motorTask, "motor_1_task", 4096, (void *)&stepper1, 2, NULL);
	// xTaskCreate(&motorTask, "motor_2_task", NULL, (void *)&stepper2, 3, NULL);
	// xTaskCreate(&motorTask, "motor_3_task", NULL, (void *)&stepper3, 3, NULL);
	// xTaskCreate(&motorTask, "motor_4_task", NULL, (void *)&stepper4, 3, NULL);
	// xTaskCreate(&motorTask, "motor_5_task", NULL, (void *)&stepper5, 3, NULL);
	// xTaskCreate(&motorTask, "motor_6_task", NULL, (void *)&stepper6, 3, NULL);
}
