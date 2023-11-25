import sys
from PyQt5.QtWidgets import QApplication, QWidget,QVBoxLayout,QPushButton, QLineEdit,QGridLayout,QGroupBox
class MyWindow(QWidget):

    def __init__(self):
        super().__init__()
        self.init_ui()
    def init_ui(self):
        self.setWindowTitle("计算器")
        data = {
            0:["7","8","9","+","("],
            1:["4","5","6","-",")"],
            2:["1","2","3","*","<-"],
            3:["0",".","=","/","c"]
        }
        # 整体布局
        layout = QVBoxLayout()

        # 第一行，输入格
        edit = QLineEdit()
        edit.setPlaceholderText("请输入内容")
        layout.addWidget(edit)

        # 第二行，button格
        gender_box = QGroupBox("grid button 组")
        grid = QGridLayout()
        for line_number, line_data in data.items():
            for col_number, number in enumerate(line_data):
                btn = QPushButton(number)
                grid.addWidget(btn, line_number, col_number)
        gender_box.setLayout(grid)
        layout.addWidget(gender_box)

        self.setLayout(layout)


if __name__ == "__main__":
    app = QApplication(sys.argv)

    w = MyWindow()
    w.show()

    app.exec()