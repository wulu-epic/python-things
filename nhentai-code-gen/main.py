import random
import pyperclip
import time, sys


a = "123456789"

codes = list()
codeswithURL = list()

inpt = input("How many codes do you want to generate: ")

for i in range(int(inpt)):
    l = list(a)
    random.shuffle(l)
    shuffle = ''.join(l)
    result = shuffle[0:6]
    print(result)
    codes.append(result)
    codeswithURL.append("nhentai.net/g/"+result)

ch = input("Done generating codes. What to do? [1] SAVE [2] COPY TO CLIPBOARD: ")

if ch=="1":
    ck = input("Do you want to save with urls or just codes? [1] ONLY CODES [2] WITH URLS: ")
    if ck == "1":
        g = open('codes.txt', 'r+')
        g.truncate(0)
    
        with open('codes.txt', 'w') as f:
            for item in codes:
                f.write("%s\n" % item)
        print("Done saving codes. Exiting in 3s")
        time.sleep(3)
        sys.exit(0)
    else:
        g = open('codes.txt', 'r+')
        g.truncate(0)
    
        with open('codes.txt', 'w') as f:
            for item in codeswithURL:
                f.write("%s\n" % item)
        print("Done saving codes. Exiting in 3s")
        time.sleep(3)
        sys.exit(0)

if ch=="2":
    cf = input("Do you want to copy with urls or only codes? [1] ONLY CODES [2] WITH URLS: ")
    if cf=="1":
        string = " ".join([str(item) for item in codes])+"\n"
        pyperclip.copy(string)
        print("Done copying to clipboard. Exiting in 3s.")
        time.sleep(3)
        sys.exit(0)
    else:
        string = " ".join([str(item) for item in codeswithURL])+"\n"
        pyperclip.copy(string)
        print("Done copying to clipboard. Exiting in 3s.")
        time.sleep(3)
        sys.exit(0)
if ch!="2" or ch!="1":
    print("Please pick a valid method.")