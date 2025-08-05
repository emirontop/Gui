from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label

class Calculator(BoxLayout):
    def __init__(self, **kwargs):
        super(Calculator, self).__init__(**kwargs)
        self.orientation = 'vertical'

        self.input1 = TextInput(hint_text='Birinci Sayı', multiline=False)
        self.input2 = TextInput(hint_text='İkinci Sayı', multiline=False)
        self.result = Label(text='Sonuç: ')

        self.add_widget(self.input1)
        self.add_widget(self.input2)

        self.add_button = Button(text='Topla')
        self.add_button.bind(on_press=self.add)
        self.add_widget(self.add_button)

        self.add_widget(self.result)

    def add(self, instance):
        try:
            num1 = float(self.input1.text)
            num2 = float(self.input2.text)
            self.result.text = f'Sonuç: {num1 + num2}'
        except ValueError:
            self.result.text = 'Lütfen geçerli sayılar girin.'

class MultiToolApp(App):
    def build(self):
        return Calculator()

if __name__ == '__main__':
    MultiToolApp().run()