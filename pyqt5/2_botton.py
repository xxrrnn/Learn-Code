import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton



if __name__ == "__main__":
    app = QApplication(sys.argv)

    w = QWidget()

    w.setWindowTitle("PyQT Button")

    btn = QPushButton("按钮")
    btn.move(6,6)
    # 设置按钮的父亲是当前窗口，添加到当前窗口
    btn.setParent(w)

    w.show()

    app.exec_()

    