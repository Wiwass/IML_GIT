This folder contains all the files for the demo of the program, to test it what you need to do is:
1. Open in 3 separate instances main_server.m, second_server.m and client_1.m
2. Run both the main_server.m and second_server.m and only then run client_1.m

This will start the process described in the section "Server Side" of the paper and the result will be the display of the transferred image.

If you also want to test the functionalities for adding a new key you need to have the main_server.m script loaded and on another instance of matlab to call the function add_key_to_DB(filename), where filename is the name (extension included) of the file you want to add; the file needs to be under "./assets/images"

Warning: the program is designed to capture images to create the keys from webcams, so it will try to open yours when launched, there is an option to generate the keys from static images, and it triggers if you have no webcams on the device.

Warning 2: if you do use a webcam and it is blocked the programm will stay idle until it can capture 2 different images, so a blocked webcam can result in an infinite loop that causes the server timeout.

The programs are fully commented but they overall lack textual outputs during execution, and that's because it is ment to run on a server.

Last but not least the functions for the prime numbers LavaLampToPrime1,LavaLampToPrime2,LavaLampToPrime3,LavaLampToPrime4 do not correspond to the numerations in the paper, but the third one in the paper corresponds to LavaLampToPrime1.