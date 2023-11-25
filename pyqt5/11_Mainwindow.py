# Qwidget
# QMainWindow : QWidget子类，包括菜单栏，工具栏、标题栏、状态栏等
# QDialog：对话框基类
import sys
from PyQt5.QtWidgets import QMainWindow, QLabel, QApplication

class MyWindow(QMainWindow):

    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        label = QLabel("这个是文字~~~")
        label.setStyleSheet("font-size:30px;color:red")

        menu = self.menuBar()

        menu.setNativeMenuBar(False)

        file_menu = menu.addMenu("Files")
        file_menu.addAction("new")
        file_menu.addAction("open")
        file_menu.addAction("save")

        file_menu = menu.addMenu("Edit")
        file_menu.addAction("copy")
        file_menu.addAction("paste")
        file_menu.addAction("cut")

 # 设置中心内容显示
        self.setCentralWidget(label)


if __name__ == '__main__':
    app = QApplication(sys.argv)

    w = MyWindow()
    # 设置窗口标题
    w.setWindowTitle("我是窗口标题....")
    # 展示窗口
    w.show()

    # 程序进行循环等待状态
    app.exec()