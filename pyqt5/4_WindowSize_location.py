import sys
from PyQt5.QtCore import QCoreApplication
import PyQt5.QtCore as QtCore
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QLabel, QLineEdit, QDesktopWidget

if __name__ == "__main__":

    app = QApplication(sys.argv)

    w = QWidget()

    w.resize(1000, 1000)

    # 移动窗口到左上角
    # w.move(0,0)

    # 调整整个窗口在屏幕中央显示
    center_pointer = QDesktopWidget().availableGeometry().center()
    x = center_pointer.x()
    y = center_pointer.y()
    # w.move(x, y)
    old_x, old_y, width, height = w.frameGeometry().getRect()
    w.move(x - int(width/2), y - int(height/2))
    w.show()

    app.exec_()