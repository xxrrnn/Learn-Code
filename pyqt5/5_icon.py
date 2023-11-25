import sys
from PyQt5.QtCore import QCoreApplication
import PyQt5.QtCore as QtCore
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QLabel, QLineEdit, QDesktopWidget
from PyQt5.QtGui import QIcon
if __name__ == "__main__":
    # 一般高级的app要隐藏标题栏
    app = QApplication(sys.argv)

    w = QWidget()

    w.setWindowTitle("一个小图标")

    w.setWindowIcon(QIcon('economist.png'))
    w.show()

    app.exec_()