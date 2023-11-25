import sys
from PyQt5.QtWidgets import QApplication, QVBoxLayout, QWidget,QPushButton,QGroupBox,QMainWindow
from PyQt5.QtCore import Qt

class MyWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.resize(1000,1000)

        self.setWindowTitle("垂直布局")

        layout = QVBoxLayout()

        btn1 = QPushButton("按钮1")
        layout.addWidget(btn1)

        btn2 = QPushButton("按钮2")
        layout.addWidget(btn2)

        btn3 = QPushButton("按钮3")
        layout.addWidget(btn3)

        # 添加一个伸缩器，相当于在下边加一个弹簧
        # layout.addStretch()

        self.setLayout(layout)


if __name__ == "__main__" :
    app = QApplication(sys.argv)

    w = MyWindow()
    w.show()

    app.exec()