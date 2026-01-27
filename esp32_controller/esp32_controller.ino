#include <Bluepad32.h>

#define NB_MAX_CONTROLLER 1

#define button1 32
#define top 19
#define left 21
#define bottom 22 
#define right 23

ControllerPtr myControllers[NB_MAX_CONTROLLER];

// This callback gets called any time a new gamepad is connected.
// Up to 4 gamepads can be connected at the same time.
void onConnectedController(ControllerPtr ctl) {
    Serial.printf("New controller detected !!\r\n");
    bool foundEmptySlot = false;
    for (int i = 0; i < NB_MAX_CONTROLLER; i++) {
        if (myControllers[i] == nullptr) {
            Serial.printf("CALLBACK: Controller is connected, index=%d\r\n", i);
            // Additionally, you can get certain gamepad properties like:
            // Model, VID, PID, BTAddr, flags, etc.
            ControllerProperties properties = ctl->getProperties();
            Serial.printf("Controller model: %s, VID=0x%04x, PID=0x%04x\r\n", ctl->getModelName().c_str(), properties.vendor_id,
                           properties.product_id);
            myControllers[i] = ctl;
            foundEmptySlot = true;
            break;
        }
    }
    if (!foundEmptySlot) {
        Serial.println("CALLBACK: Controller connected, but could not found empty slot\r\n");
    }
}

void onDisconnectedController(ControllerPtr ctl) {
    bool foundController = false;

    for (int i = 0; i < NB_MAX_CONTROLLER; i++) {
        if (myControllers[i] == ctl) {
            Serial.printf("CALLBACK: Controller disconnected from index=%d\r\n", i);
            myControllers[i] = nullptr;
            foundController = true;
            break;
        }
    }

    if (!foundController) {
        Serial.println("CALLBACK: Controller disconnected, but not found in myControllers\r\n");
    }
}

void dumpGamepad(ControllerPtr ctl) {
    uint16_t buttons = (ctl->buttons() & 0b1111); // only keep the first 4 bits
    uint32_t left_stick_x = ctl->axisX();
    uint32_t left_stick_y = ctl->axisY();


    // si un des input est appuyé
    if(buttons > 0 || left_stick_x > 200  || int(left_stick_x) < (-200) || left_stick_y > 200 || int(left_stick_y) < (-200) ){
        bool but1_pushed = buttons & 0b1;
        bool stick_to_left = int(left_stick_x) < (-200);
        bool stick_to_right = int(left_stick_x) > 200;
        bool stick_to_top = int(left_stick_y) > 200;
        bool stick_to_bottom = int(left_stick_y) < (-200);


        analogWrite(button1, but1_pushed);
        analogWrite(left, stick_to_left );
        analogWrite(right, stick_to_right );
        analogWrite(top, stick_to_top );
        analogWrite(bottom, stick_to_bottom);

        Serial.printf("but1_pushed = " + but1_pushed);
        Serial.printf("stick_to_top = " + stick_to_top);
        Serial.printf("stick_to_left = " + stick_to_left);
        Serial.printf("stick_to_bottom = " + stick_to_bottom);
        Serial.printf("stick_to_right = " + stick_to_right);
        Serial.printf("\r\n");
    }
}

void processGamepad(ControllerPtr ctl) {
    if (ctl->a()) {
        static int colorIdx = 0;
        switch (colorIdx % 3) {
            case 0:
                // Red
                ctl->setColorLED(255, 0, 0);
                break;
            case 1:
                // Green
                ctl->setColorLED(0, 255, 0);
                break;
            case 2:
                // Blue
                ctl->setColorLED(0, 0, 255);
                break;
        }
        colorIdx++;
    }

    if (ctl->b()) {
        // Turn on the 4 LED. Each bit represents one LED.
        static int led = 0;
        led++;
        ctl->setPlayerLEDs(led & 0x0f);
    }

    if (ctl->x()) {
        ctl->playDualRumble(0 /* delayedStartMs */, 250 /* durationMs */, 0x80 /* weakMagnitude */,
                            0x40 /* strongMagnitude */);
    }

    // Another way to query controller data is by getting the buttons() function.
    // See how the different "dump*" functions dump the Controller info.
    dumpGamepad(ctl);
}

void processControllers() {
    for (auto myController : myControllers) {
        if (myController && myController->isConnected() && myController->hasData() && myController->isGamepad()) {
            processGamepad(myController);
        }
    }
}

// Arduino setup function. Runs in CPU 1
void setup() {
    // setup controller bluetooth
    Serial.begin(115200);
    Serial.printf("Firmware: begin%s\n", BP32.firmwareVersion());
    const uint8_t* addr = BP32.localBdAddress();
    Serial.printf("BD Addr: %2X:%2X:%2X:%2X:%2X:%2X\r\n", addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);

    BP32.setup(&onConnectedController, &onDisconnectedController);
    BP32.forgetBluetoothKeys();
    BP32.enableVirtualDevice(false);

    pinMode(button1, OUTPUT); 
    pinMode(top, OUTPUT); 
    pinMode(left, OUTPUT); 
    pinMode(bottom, OUTPUT); 
    pinMode(right, OUTPUT); 
}

int a_state = 0;

// Arduino loop function. Runs in CPU 1.
void loop() {

    bool dataUpdated = BP32.update();
    if (dataUpdated)
        processControllers();

    //delay(150);
    if (Serial.available() > 0) {
        char key = Serial.read();

        switch (key) {

            // ---- KEY PRESSED (LOWERCASE) ----
            case 'z':
                Serial.println("advancing");
                digitalWrite(top, HIGH);
                digitalWrite(bottom, LOW);
                digitalWrite(right, LOW);
                digitalWrite(left, LOW);
                break;

            case 's':
                Serial.println("backing");
                digitalWrite(top, LOW);
                digitalWrite(bottom, HIGH);
                digitalWrite(right, LOW);
                digitalWrite(left, LOW);
                break;

            case 'q':
                Serial.println("To the Left");
                digitalWrite(left, HIGH);
                digitalWrite(right, LOW);
                digitalWrite(bottom, LOW);
                digitalWrite(top, LOW);
                break;

            case 'd':
                Serial.println("To the Right");
                digitalWrite(right, HIGH);
                digitalWrite(left, LOW);
                digitalWrite(bottom, LOW);
                digitalWrite(top, LOW);
                break;

            case 'a':
                if (a_state == 1) {
                    Serial.println("A off ");
                    digitalWrite(button1, LOW);
                    a_state = 0;
                }
                else {
                    digitalWrite(button1, HIGH);
                    Serial.println("A on ");
                    a_state = 1;
                }
                
                break;

            case 'e':
                Serial.println("E pushed");
                digitalWrite(right, LOW);
                digitalWrite(left, LOW);
                digitalWrite(bottom, LOW);
                digitalWrite(top, LOW);                
            break;
        }
    }
}
