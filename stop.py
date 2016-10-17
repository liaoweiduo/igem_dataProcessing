import serial
import threading
from time import sleep

isReceived = 0
ser = serial.Serial("COM3", 9600)

def work():

    '''
    send("E901044357580148")                #start
    send("E901044357580049")                #stop
    send("E9010A4357540105000705000E43")    #5ml 5ul/min
    send("E9010A4357540105000706000846")   	#5ml 6.25ul/min
    send("E9010A4357540105000707000847")    #5ml 7ul/min
    send("E9010A435754010500070A00084A")    #5ml 10ul/min
    send("E9010A435754010500070F000E49")    #5ml 15ul/min
    send("E9010A4357540105000719000859")    #5ml 25ul/min
    send("E9010A4357540105000732000872")    #5ml 50ul/min
    send("E9010A4357540105000764000824")    #5ml 100ul/min
    send("E9010A43575401050007C8000888")    #5ml 200ul/min
    send("E9010A43575401050007F40108B5")    #5ml 500ul/min
    send("E9010A43575401050007E8000308AB")  #5ml 1000ul/min
    send("E9010A43575401050007D0070897")    #5ml 2000ul/min
    sleep(5)
    '''

    send("E901044357580049")                #stop





def receive():
    global isReceived, ser
    print("start listening:")
    while 1:
        message = ser.read()
        if message != 1:
            isReceived = 1
            print(message)
        sleep(0.1)

def send(s):
    global isReceived, ser
    temp = 0
    while temp < 2 and isReceived == 0:
        for i in range(0, len(s), 2):
            message = s[i : i + 2].decode("hex")
            ser.write(message)
        temp += 1
        sleep(0.5)
    if isReceived == 0:
        print("donot receive back message")
    isReceived = 0


t = threading.Thread(target=receive)
t.start()
sleep(0.5)
work()