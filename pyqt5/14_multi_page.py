import sys
from PyQt6.QtWidgets import QApplication, QMainWindow, QPushButton, QWidget, QVBoxLayout, QStackedWidget

class WindowSwitcher(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Window Switcher")
        self.setGeometry(100, 100, 800, 600)

        self.central_widget = QWidget(self)
        self.setCentralWidget(self.central_widget)

        self.layout = QVBoxLayout(self.central_widget)

        self.stacked_widget = QStackedWidget(self.central_widget)

        # 创建两个不同的窗口（页面）
        self.window1 = QWidget()
        self.window2 = QWidget()

        # 在窗口1中添加一些内容
        self.button1 = QPushButton("Go to Window 2", self.window1)
        self.button1.clicked.connect(self.switch_to_window2)

        # 在窗口2中添加一些内容
        self.button2 = QPushButton("Go to Window 1", self.window2)
        self.button2.clicked.connect(self.switch_to_window1)

        # 向QStackedWidget添加窗口1和窗口2
        self.stacked_widget.addWidget(self.window1)
        self.stacked_widget.addWidget(self.window2)

        # 默认显示窗口1
        self.stacked_widget.setCurrentWidget(self.window1)

        # 添加QStackedWidget到布局
        self.layout.addWidget(self.stacked_widget)

    def switch_to_window1(self):
        self.stacked_widget.setCurrentWidget(self.window1)

    def switch_to_window2(self):
        self.stacked_widget.setCurrentWidget(self.window2)

def main():
    app = QApplication(sys.argv)
    window = WindowSwitcher()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()
