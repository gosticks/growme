#include "MotorControl.hpp"

void CustomBLEMotorCallback::onWrite(BLECharacteristic *characteristic) {
	const char *tag = "BLEMotor";

	ESP_LOGI(tag, "onWrite for motor %d", this->motorIndex);
	// decode pb message from bluetooth characteristic
	pb_istream_t stream =
		pb_istream_from_buffer(characteristic->getData(), characteristic->getLength());
	if (pb_decode(&stream, Command_fields, &cmd)) {
		switch (cmd.which_msg) {
			case Command_reset_tag:
				ESP_LOGI(tag, "reset motor command received");
				this->controller->stepTarget = 0;
				this->controller->currentPosition = 0;
				break;
			case Command_move_tag:
				this->controller->stepTarget += cmd.msg.move.target;
				ESP_LOGI(tag,
						 "received new sample %d, new target %ld",
						 cmd.msg.move.target,
						 this->controller->stepTarget);
				break;
			default: ESP_LOGW(tag, "received unhandled command type %d", cmd.which_msg);
		}
	};
};

const char *TAG = "MotorCallback";

void CustomBLEMotorCallback::onRead(BLECharacteristic *ch) {
	ESP_LOGI("MotorCallback", "onRead");
};

void CustomBLEMotorInfoCallback::onRead(BLECharacteristic *characteristic) {
	// encode message in pb format
	pb_ostream_t stream = pb_ostream_from_buffer(this->buffer, sizeof(this->buffer));

	this->msg.totalSteps = this->controller->currentPosition;

	if (!pb_encode(&stream, Command_fields, &this->msg)) {
		ESP_LOGE(TAG, "failed to encode: %s", PB_GET_ERROR(&stream));
		return;
	}

	// encode latest value in characteristic
	characteristic->setValue(buffer, stream.bytes_written);
};

MotorControl::MotorControl(uint8_t index, short dir, short step) {
	this->stepper = new A4988(MOTOR_STEPS, dir, step);
	this->index = index;
};

void MotorControl::addControlCharacteristic(BLECharacteristic *bleCharac) {
	this->bleCharacteristic = bleCharac;

	ESP_LOGI(TAG, "adding control characteristic for motor %d", this->index);

	// add callback
	this->bleCharacteristic->setCallbacks(new CustomBLEMotorCallback(index, this));
};

void MotorControl::addInfoCharacteristic(BLECharacteristic *bleCharac) {
	this->bleInfoCharacteristic = bleCharac;

	ESP_LOGI(TAG, "adding info characteristic for motor %d", this->index);

	// add callback
	this->bleInfoCharacteristic->setCallbacks(new CustomBLEMotorInfoCallback(index, this));
};