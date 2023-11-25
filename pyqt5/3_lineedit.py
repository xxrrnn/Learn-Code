import sys
from PyQt5.QtCore import QCoreApplication
import PyQt5.QtCore as QtCore
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QLabel, QLineEdit

if __name__ == "__main__":
    # 加入这个解决窗口大小不匹配问题
    QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)
    app = QApplication(sys.argv)

    w = QWidget()

    w.setWindowTitle("第一个PyQt")
    # method 1
    # label = QLabel("账号： ")
    # label.setParent(w)

    # method 2
    label = QLabel("账号：" ,w)

    label.setGeometry(20,20,30,30)

    edit = QLineEdit(w)
    edit.setPlaceholderText("请输入账号：")
    edit.setGeometry(55,22,200,20)

    btn = QPushButton("注册",w)
    btn.setGeometry(50,80,70,30)


    w.show()

    app.exec_()

