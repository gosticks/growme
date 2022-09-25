#include <stdio.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <WiFi.h>
#include <Arduino.h>

#include "sdkconfig.h"
#include "A4988.h"

#define UP_BTN_PIN 2
#define DOWN_BTN_PIN 15

// using a 200-step motor (most common)
#define MOTOR_STEPS 200
// configure the pins connected
#define DIR 17
#define STEP 16

A4988 stepper(MOTOR_STEPS, DIR, STEP);

// TODO: for now use simple arduino based
// task structure adjust as needed afterwards
void arduinoTask(void *pvParameter)
{
    // setup serial COMs
    Serial.begin(115200);

    // configure button
    pinMode(UP_BTN_PIN, INPUT);
    pinMode(DOWN_BTN_PIN, INPUT);

    // configure motor
    stepper.begin(120, 1);

    // motor movement direction
    // -1 = counter clockwise
    // 0  = nothing
    // 1  = clockwise
    int direction = 0;

    // track current movement of motor
    uint motorWaitTimeMicros = 0;

    // time for RTOS to use when motor is not spinning
    uint noActionIdleTime = pdMS_TO_TICKS(100);

    // pick large angle to rotate, such that motor will not stop between loop iterations
    // and RTOS has time to do other things
    int rotationAngle = 100 * 360;

    // add a delay for the MCU to apply setup
    delay(100);

    while (1)
    {
        // parse movement direction
        if (digitalRead(UP_BTN_PIN) == HIGH)
        {
            direction = 1;
        }
        else if (digitalRead(DOWN_BTN_PIN) == HIGH)
        {
            direction = -1;
        }
        else
        {
            direction = 0;
        }

        // start spinning motor if:
        // - button pressed
        // - no spin command was already started
        if (direction == 0)
        {
            stepper.stop();
        }
        else
        {
            stepper.startRotate(direction * rotationAngle);
        }

        // motor control loop - send pulse and return how long to wait until next pulse
        motorWaitTimeMicros = stepper.nextAction();
        if (motorWaitTimeMicros <= 0)
        {

            vTaskDelay(noActionIdleTime);
        }
        else if (motorWaitTimeMicros >= 50)
        {
            vTaskDelay(pdMS_TO_TICKS(motorWaitTimeMicros / 1000));
        }
        else
        {
            // give tiny amount for RTOS scheduling
            vTaskDelay(20);
        }
    }
}

extern "C" void app_main()
{
    // initialize arduino library before we start the tasks
    initArduino();

    xTaskCreate(&arduinoTask, "arduino_task", 8192, NULL, 5, NULL);
}
