#pragma once
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <freertos/FreeRTOS.h>

#include "A4988.h"
#include "esp_log.h"
#include "message.pb.h"
#include "pb_decode.h"
#include "pb_encode.h"

// using a 200-step motor (most common)
#define MOTOR_STEPS 200

struct MotorControl {
	uint8_t index;
	A4988 *stepper;
	long stepTarget = 0;
	long currentPosition = 0;
	BLECharacteristic *bleCharacteristic = NULL;

	MotorControl(uint8_t index, short dir, short step);

	void addControlCharacteristic(BLECharacteristic *bleCharac);

	void updateCurrentPosition(long newPosition);
};

class CustomBLEMotorCallback : public BLECharacteristicCallbacks {
	int motorIndex;
	MotorControl *controller;

	Command cmd = Command_init_zero;

	void onWrite(BLECharacteristic *characteristic);
	void onRead(BLECharacteristic *ch);

   public:
	CustomBLEMotorCallback(uint8_t motorIndex, MotorControl *controller) {
		this->motorIndex = motorIndex;
		this->controller = controller;
	};
};

class CustomBLEMotorInfoCallback : public BLECharacteristicCallbacks {
	MotorControl **motors;
	size_t numMotors;
	MotorStatus msg;

	// set internal position value
	uint8_t buffer[256];

	void onRead(BLECharacteristic *ch);

   public:
	CustomBLEMotorInfoCallback(MotorControl *motors[]) {
		this->motors = motors;
		// TODO: compute dynamically
		numMotors = 6;
	};
};