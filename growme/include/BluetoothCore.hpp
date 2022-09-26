#pragma once
#include <freertos/FreeRTOS.h>
#include <freertos/message_buffer.h>
#include <freertos/queue.h>

#include <functional>
#include <string>

namespace BluetoothCore {
/**
 * @brief setup ESP SPP bluetooth + Stack
 *
 * @return true setup okay
 * @return false setup failed
 */
bool setup();

/**
 * @brief remove queues, tasks and teardown ESP bt stack
 *
 */
void teardown();

MessageBufferHandle_t getCmdReceiverMsgBuffer();
QueueHandle_t getCmdSenderQueue();
}  // namespace BluetoothCore