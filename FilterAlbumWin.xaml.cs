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

namespace MusicDB_PROJECT
{
    /// <summary>
    /// Логика взаимодействия для FilterWin.xaml
    /// </summary>
    public partial class FilterAlbumWin : Window
    {
        public FilterAlbumWin()
        {
            InitializeComponent();
        }

        MusicDBEntities db = MusicDBEntities.GetContext();
        bool filterOtrabotat= false;

        private void Filter_Click(object sender, RoutedEventArgs e)
        {
            if (comboBox.SelectedItem != null)
            {
                Data.ID = comboBox.SelectedIndex+1;
                filterOtrabotat = true;

                Close();
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            ComboBoxItem comboItem;

            foreach (var i in db.Genres)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = i.Id.ToString() + " " + i.Name;
                comboBox.Items.Add(comboItem);
            }

            comboBox.SelectedIndex = 0;
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if (filterOtrabotat == false)
            {
                e.Cancel = true;
            }
            else
            {
                e.Cancel= false;
            }
        }
    }
}
