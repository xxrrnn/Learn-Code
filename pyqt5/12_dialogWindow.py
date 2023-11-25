import sys

from PyQt5.QtWidgets import QDialog, QPushButton, QApplication


class MyDialog(QDialog):

    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        ok_btn = QPushButton("确定", self)
        ok_btn.setGeometry(50, 50, 100, 30)


if __name__ == '__main__':
    app = QApplication(sys.argv)

    w = MyDialog()
    # 设置窗口标题
    w.setWindowTitle("对话框")
    # 展示窗口
    w.show()

    # 程序进行循环等待状态
    app.exec()
