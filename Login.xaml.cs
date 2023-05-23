using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace MusicDB_PROJECT
{
    /// <summary>
    /// Логика взаимодействия для Login.xaml
    /// </summary>
    public partial class Login : Window
    {
        public Login()
        {
            InitializeComponent();
        }

        DispatcherTimer timer;
        int countLogin = 1;
        MusicDBEntities db = MusicDBEntities.GetContext();

        // Функция для генерации и отображения капчи
        void GetCaptcha()
        {
            string masChar = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890";
            string captcha = "";
            Random rnd = new Random();
            for (int i = 1; i <= 6; i++)
                captcha += masChar[rnd.Next(0, masChar.Length)];
            grid.Visibility = Visibility.Visible;
            txtCaptcha.Text = captcha;
            tbCaptcha.Text = null;
            txtCaptcha.LayoutTransform = new RotateTransform(rnd.Next(-15, 15));
            line.X1 = 10;
            line.Y1 = rnd.Next(10, 40);
            line.X2 = 280;
            line.Y2 = rnd.Next(10, 40);
        }

        private void Enter_Click(object sender, RoutedEventArgs e)
        {
            // Поиск пользователя по введённому логину и проверка пароля
            var user = from p in db.Users
                       where p.UserName == tbLogin.Text &&
                       p.Password == pwBox.Password
                       select p;
            if (user.Count() == 1 && txtCaptcha.Text == tbCaptcha.Text)
            {
                Data.Login = true;
                Data.FullName = user.First().FullName;
                Data.Right = user.First().Role.RoleName;
                Close();
            }
            else
            {
                if (user.Count() == 1) MessageBox.Show("Капча неверна.");
                else MessageBox.Show("Логин и/или пароль неверны.");
                GetCaptcha();
            }
            if (countLogin >= 2)
            {
                stackPanel.IsEnabled = false;
                timer.Start();
            }
            countLogin++;
            tbLogin.Focus();
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void GuestEnter_Click(object sender, RoutedEventArgs e)
        {
            Data.Login = true;
            Data.FullName = "Гость";
            Data.Right = "Клиент";
            Close();
        }

        private void Window_Activated(object sender, EventArgs e)
        {
            tbLogin.Focus();
            Data.Login = false;
            timer = new DispatcherTimer();
            timer.Interval = new TimeSpan(0, 0, 10);
            timer.Tick += new EventHandler(timer_Tick);
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            stackPanel.IsEnabled = true;
        }
    }
}
