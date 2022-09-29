#include "MotorControl.hpp"

#include <EEPROM.h>

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

struct RepeatedStatus {
	int32_t *status;
	int index;
	size_t max_size;
};

bool status_encode(pb_ostream_t *stream, const pb_field_t *field, void *const *arg) {
	ESP_LOGI(TAG, "write callback stated");

	RepeatedStatus *def = (RepeatedStatus *)*arg;
	while (def->index < def->max_size) {
		int32_t status = def->status[def->index];
		++def->index;

		if (!pb_encode_tag(stream, PB_WT_VARINT, field->tag)) {
			ESP_LOGE(TAG, "failed to encode: %s", PB_GET_ERROR(stream));
			return false;
		}

		if (!pb_encode_varint(stream, status)) {
			ESP_LOGE(TAG, "failed to encode: %s", PB_GET_ERROR(stream));
			return false;
		}

		ESP_LOGI(TAG, "written value %d", status);
	}

	ESP_LOGI(TAG, "write callback completed");

	return true;
}

void CustomBLEMotorInfoCallback::onRead(BLECharacteristic *characteristic) {
	// encode message in pb format
	pb_ostream_t stream = pb_ostream_from_buffer(this->buffer, sizeof(this->buffer));

	int32_t status[numMotors];

	for (int i = 0; i < this->numMotors; i++) {
		status[i] = this->motors[i]->currentPosition;
	}

	ESP_LOGI(TAG, "status items %d", numMotors);

	struct RepeatedStatus args = {.status = status, .index = 0, .max_size = this->numMotors};

	msg.status.arg = &args;
	msg.status.funcs.encode = status_encode;

	if (!pb_encode(&stream, Command_fields, &msg)) {
		ESP_LOGE(TAG, "failed to encode: %s", PB_GET_ERROR(&stream));
		return;
	}

	ESP_LOGI(TAG, "encoded status msg %d", stream.bytes_written);

	// encode latest value in characteristic
	characteristic->setValue(buffer, stream.bytes_written);
	characteristic->setNotifyProperty(true);
};

MotorControl::MotorControl(uint8_t index, short dir, short step) {
	this->stepper = new A4988(MOTOR_STEPS, dir, step, 5);
	this->index = index;
	int address = index * 8;

	// reload position from EEPROM
	long four = EEPROM.read(address);
	long three = EEPROM.read(address + 1);
	long two = EEPROM.read(address + 2);
	long one = EEPROM.read(address + 3);

	this->currentPosition = ((four << 0) & 0xFF) + ((three << 8) & 0xFFFF) +
							((two << 16) & 0xFFFFFF) + ((one << 24) & 0xFFFFFFFF);
	this->stepTarget = this->currentPosition;
};

void MotorControl::addControlCharacteristic(BLECharacteristic *bleCharac) {
	this->bleCharacteristic = bleCharac;

	ESP_LOGI(TAG, "adding control characteristic for motor %d", this->index);

	// add callback
	this->bleCharacteristic->setCallbacks(new CustomBLEMotorCallback(index, this));
};

void MotorControl::updateCurrentPosition(long newPosition) {
	currentPosition = newPosition;
	int address = index * 8;
	byte four = (newPosition & 0xFF);
	byte three = ((newPosition >> 8) & 0xFF);
	byte two = ((newPosition >> 16) & 0xFF);
	byte one = ((newPosition >> 24) & 0xFF);

	EEPROM.write(address, four);
	EEPROM.write(address + 1, three);
	EEPROM.write(address + 2, two);
	EEPROM.write(address + 3, one);
}