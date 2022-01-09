from os import execlp, path, truncate
from tkinter import Tk, filedialog
import time

import urllib.request
from bs4 import BeautifulSoup

dialog = Tk()



print("Select a username list.")

def check(url):
    page = urllib.request.urlopen(url)
    a = BeautifulSoup(page, "html.parser")
    return a.find_all("div")
    
 

 
    
time.sleep(.5)

dialog.filename = filedialog.askopenfile(title="Open File", filetypes=( ("Text File", "*.txt"), ("All Files", "*.*" ) ))

print("File of usernames: ",dialog.filename.name)

with open(dialog.filename.name, "r") as f:
    content = f.read()
    base = "https://www.instagram.com/"

    fullString = str(base+content)

    print(check(url=fullString))