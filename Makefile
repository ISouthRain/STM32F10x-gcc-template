###############################################
# 工具链
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
###############################################

###############################################
# 链接文件和启动文件位置
LD_SCRIPT = Lib/STM32F103RCTx_FLASH.ld
STARTUP_FILE = Lib/CMSIS/startup/TrueSTUDIO/startup_stm32f10x_hd.s
###############################################

###############################################
# 所有头文件路径
INCLUDE_DIRS = -ILib/FWLib/inc -ILib/CMSIS -IUser
###############################################

###############################################
# 编译选项
# 芯片定义
C_DEFS = -DSTM32F10X_HD -DUSE_STDPERIPH_DRIVER
CPU_FLAGS = -mthumb -mcpu=cortex-m3
CFLAGS = $(CPU_FLAGS) $(INCLUDE_DIRS) $(C_DEFS) -Wall -fdata-sections -ffunction-sections
LDFLAGS = $(CPU_FLAGS) -T$(LD_SCRIPT) --specs=nosys.specs -Wl,--gc-sections
###############################################

###############################################
# C 文件源文件路径
# 用户源代码文件列表
USER_SOURCES = $(wildcard User/*.c)
# 外设源代码文件列表
PERIPH_SOURCES = $(wildcard Lib/FWLib/src/*.c)
# CMSIS 源代码文件列表
CMSIS_SOURCES = $(wildcard Lib/CMSIS/*.c)
# 所有源代码文件列表
SOURCES = $(STARTUP_FILE) $(USER_SOURCES) $(PERIPH_SOURCES) $(CMSIS_SOURCES)
###############################################

###############################################
# 生成的可执行文件名称
TARGET = Your-Project-name
###############################################

all: $(TARGET).bin $(TARGET).hex

$(TARGET).elf: $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $(LDFLAGS) -o $@

# 生成 .bin 和 .hex 文件
%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@

clean:
	rm -f $(TARGET).elf $(TARGET).bin $(TARGET).hex

.PHONY: all clean
