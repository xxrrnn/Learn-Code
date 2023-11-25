import numpy as np
import sys
import os
sys.path.append(os.pardir)

def numerical_gradient(f, x):
    h = 1e-4
    grad = np.zeros_like(x)

    it = np.nditer(x, flags=['multi_index'], op_flags=['readwrite'])
    while not it.finished:
        idx = it.multi_index
        tmp_val = x[idx]
        x[idx] = float(tmp_val) + h
        fxh1 = f(x)

        x[idx] = float(tmp_val) - h
        fxh2 = f(x)
        grad[idx] = (fxh1 - fxh2) / (2*h)

        x[idx] = tmp_val
        it.iternext()
    return grad

class TwoLayerNet_hands_on:
    def __init__(self,input_size,hidden_size,output_size):
        self.params = {}
        self.params['W1'] = np.random.randn(input_size,hidden_size)
        self.params['b1'] = np.random.randn(hidden_size)
        self.params['W2'] = np.random.randn(hidden_size,output_size)
        self.params['b2'] = np.random.randn(output_size)
    def softmax(self,z):
        c = np.max(z)
        dominator = np.sum(np.exp(z - c))
        return np.exp(z - c) / dominator

    def predict(self,x):
        W1,W2,b1,b2 = self.params['W1'], self.params['W2'], self.params['b1'], self.params['b2']
        a1 = np.dot(x,W1) + b1
        z1 = self.softmax(a1)
        a2 = np.dot(z1,W2) + b2
        z2 = self.softmax(a2)
        return z2
    def cross_entropy_error(self,y,t):
        if y.ndim == 1:
            y = np.reshape(1, y.size)
            t = np.reshape(1, t.size)
        batch_size = y.shape[0]
        return -np.sum(t * np.log(y + 1e-7))/batch_size

    def loss(self,x,t):
        y = self.predict(x)
        return self.cross_entropy_error(y,t)

    def accuracy(self,x,t):
        y = self.predict(x)
        y = np.argmax(y,axis =1)
        t = np.argmax(t, axis=1)
        accuracy = np.sum(y == t) / float(x.shape[0])
        return accuracy
    def numerical_gradient(self,x,t):
        lossW = lambda W : self.loss(x,t)
        grads = {}
        grads['W1'] = numerical_gradient(lossW,self.params['W1'])
        rads['b1'] = numerical_gradient(lossW, self.params['b1'])
        grads['W2'] = numerical_gradient(lossW, self.params['W2'])
        grads['b2'] = numerical_gradient(lossW, self.params['b2'])
        return grads

import numpy as np
from sample_code.dataset.mnist import load_mnist
# from sample_code.ch04.two_layer_net import TwoLayerNet
(x_train, t_train), (x_test, t_test) = load_mnist(normalize=True, one_hot_label = True)
train_loss_list = []
train_acc_list = []
test_acc_list = []

# 超参数
iters_num = 100
train_size = x_train.shape[0]
batch_size = 100
learning_rate = 0.1
# 平均每个epoch的重复次数
iter_per_epoch = max(train_size / batch_size, 1)
network = TwoLayerNet_hands_on(input_size=784, hidden_size=50, output_size=10)
for i in range(iters_num):
    print(i)
    # 获取mini-batch
    batch_mask = np.random.choice(train_size, batch_size)
    print(batch_mask.shape)
    x_batch = x_train[batch_mask]
    t_batch = t_train[batch_mask]
    # 计算梯度
    grad = network.numerical_gradient(x_batch, t_batch)
    # grad = network.gradient(x_batch, t_batch) # 高速版!
    # 更新参数
    for key in ('W1', 'b1', 'W2', 'b2'):
        network.params[key] -= learning_rate * grad[key]
    # 记录学习过程
    loss = network.loss(x_batch, t_batch)
    train_loss_list.append(loss)
    # 计算每个epoch的识别精度
    if i % iter_per_epoch == 0:
        train_acc = network.accuracy(x_train, t_train)
        test_acc = network.accuracy(x_test, t_test)
        train_acc_list.append(train_acc)
        test_acc_list.append(test_acc)
        print("train acc, test acc | " + str(train_acc) + ", " + str(test_acc))