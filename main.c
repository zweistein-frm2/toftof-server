#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dyad/src/dyad.h"


typedef struct {
    int timestamp50ns : 20;
    int channel : 12;
} TofTof;

TofTof buf[1000];

long timestamp = 0;

static void onData(dyad_Event* e) {
    static char dheader[20];
	
	/*
	here we can just read in our data (up to 1000) and write it to the tcp buf
	
	*/
    
	int elem = 977;
    // int elem = VMbus.DataAvailable()
	for (int i = 0; i < elem; i++) {
        buf[i].timestamp50ns = timestamp++;
		//buf[i].channel = VMEBus.GetData(i);
    }
	
    //elem = 0;
   
    e->data = (char *) buf;
    e->size = sizeof(TofTof) * elem;
    if (elem == 0) {
        e->data = "\n";
        e->size = 1;
    }
    dyad_write(e->stream, e->data, e->size);


   

}

static void onAccept(dyad_Event* e) {
    dyad_addListener(e->remote, DYAD_EVENT_DATA, onData, NULL);
 }

static void onError(dyad_Event* e) {
    printf("server error: %s\n", e->msg);
}




int main(void) {

    dyad_Stream* s;
    printf("listening on port 8000\r\n");
    dyad_init();
    s = dyad_newStream();
    dyad_addListener(s, DYAD_EVENT_ERROR, onError, NULL);
    dyad_addListener(s, DYAD_EVENT_ACCEPT, onAccept, NULL);
   
    dyad_listen(s, 8000);
   
    while (dyad_getStreamCount() > 0) {
      
        dyad_update();
    }
   

    return 0;
}
