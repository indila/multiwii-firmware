#if defined(LED_RING)

#define LED_RING_ADDRESS 0xDA //8 bits  -- my initial :)

void i2CLedRingState() {
  uint8_t b[10];
  static uint8_t state;
  
  if (state == 0) {
    b[0]='z'; 
    b[1]= (180-heading)/2; // 1 unit = 2 degrees;
    i2c_rep_start(LED_RING_ADDRESS);
    for(uint8_t i=0;i<2;i++)
      i2c_write(b[i]);
    i2c_stop();
    state = 1;
  } else if (state == 1) {
    b[0]='y'; 
    b[1]= constrain(angle[ROLL]/10+90,0,180);
    b[2]= constrain(angle[PITCH]/10+90,0,180);
    i2c_rep_start(LED_RING_ADDRESS);
    for(uint8_t i=0;i<3;i++)
      i2c_write(b[i]);
    i2c_stop();
    state = 2;
  } else if (state == 2) {
    b[0]='d'; // all unicolor GREEN 
    b[1]= 1;
    if (armed) b[2]= 1; else b[2]= 0;
    i2c_rep_start(LED_RING_ADDRESS);
    for(uint8_t i=0;i<3;i++)
      i2c_write(b[i]);
    i2c_stop();
    state = 0;
  }
}

void blinkLedRing() {
  uint8_t b[3];
  b[0]='k';
  b[1]= 10;
  b[2]= 10;
  i2c_rep_start(LED_RING_ADDRESS);
  for(uint8_t i=0;i<3;i++)
    i2c_write(b[i]);
  i2c_stop();
}

#if defined(LANDING_LIGHTS_DDR)
void init_landing_lights(void) {
	LANDING_LIGHTS_DDR |= 1<<LANDING_LIGHTS_BIT;
}

void switch_landing_lights(uint8_t on) {
	if (on) {
		LANDING_LIGHTS_PORT |= 1<<LANDING_LIGHTS_BIT;
	} else {
		LANDING_LIGHTS_PORT &= ~(1<<LANDING_LIGHTS_BIT);
	}
}

void auto_switch_landing_lights(void) {
	#if defined(LANDING_LIGHTS_AUTO_ALTITUDE) & SONAR
	if (sonarAlt >= 0 && sonarAlt <= LANDING_LIGHTS_AUTO_ALTITUDE && armed) {
		switch_landing_lights(1);
	} else {
		switch_landing_lights(0);
	}
	#endif
}
#endif

#endif
