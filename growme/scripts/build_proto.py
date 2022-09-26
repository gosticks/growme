import os
Import("env")

print("Current CLI targets", COMMAND_LINE_TARGETS)
print("Current Build targets", BUILD_TARGETS)

os.system("python3 .pio/libdeps/esp32dev/Nanopb/generator/nanopb_generator.py proto/message.proto --strip-path")
os.system("mv ./proto/message.pb.c ./src/message.pb.c")
os.system("mv ./proto/message.pb.h ./include/message.pb.h")
