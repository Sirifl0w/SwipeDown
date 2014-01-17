ARCHS = armv7 armv7s arm64
export GO_EASY_ON_ME = 1

THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = SwipeDown
SwipeDown_FILES = SwipeDown.xm
SwipeDown_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
