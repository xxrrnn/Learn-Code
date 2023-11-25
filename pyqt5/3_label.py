import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QLabel

if __name__ == "__main__":
    app = QApplication(sys.argv)

    w = QWidget()

    w.setWindowTitle("PyQT Button")
    # method 1
    # label = QLabel("账号： ")
    # label.setParent(w)

    # method 2
    label = QLabel("账号：" ,w)

    label.setGeometry(50,50,100,100)
    w.show()

    app.exec_()

