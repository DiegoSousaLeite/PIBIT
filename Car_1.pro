QT += quick qml

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        radialbar.cpp

RESOURCES += qml.qrc


QML_IMPORT_PATH =


QML_DESIGNER_IMPORT_PATH =


qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	radialbar.h
