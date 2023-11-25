import sys
from PyQt5.QtWidgets import QApplication, QWidget,QPushButton,QVBoxLayout,QFormLayout, QLineEdit,QGridLayout,QGroupBox
from PyQt5.QtCore import Qt
class MyWindow(QWidget):

    def __init__(self):
        super().__init__()
        self.init_ui()
    def init_ui(self):

        self.setFixedSize(300,150)

        container = QVBoxLayout()

        form_layout = QFormLayout()

        edit = QLineEdit()
        edit.setPlaceholderText("请输入账号")
        edit2 = QLineEdit()
        edit2.setPlaceholderText("请输入密码")
        form_layout.addRow("账号：", edit)
        form_layout.addRow("密码：", edit2)
        container.addLayout(form_layout)

        btn = QPushButton("登录")
        btn.setFixedSize(100,30)
        container.addWidget(btn,alignment=Qt.AlignRight)

        self.setLayout(container)



if __name__ == "__main__":
    app = QApplication(sys.argv)

    w = MyWindow()
    w.show()

    app.exec()