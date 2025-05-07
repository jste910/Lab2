import os
print(os.getcwd())

# go into the ip folder
os.chdir("ip")
print(os.getcwd())
cmd = ""
# recurisively find all .vhd files in the current directory and subdirectories
for root, dirs, files in os.walk(os.getcwd()):
    for file in files:
        if file.endswith(".vhd"):
            # get the full path of the file
            filePath = os.path.join(root, file)
            cmd += "vcom -work ip " + filePath + "; " # + filePath

# filePath = r"C:\altera\13.0\CS701\ip\AudioClock_1\AudioClock.vhd"
# cmd = "vcom -work ip " + filePath

cmd = cmd.replace("\\", "/") # replace \ with /

print(cmd)
# cmdlst = cmd.split(";")
# for i in cmdlst:
#     if i != "":
#         print(i)



# find ip folder
# cmd = "vcom -work ip " # + filePath
