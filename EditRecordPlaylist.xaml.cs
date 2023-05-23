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
    /// Логика взаимодействия для AddRecordPlaylist.xaml
    /// </summary>
    public partial class EditRecordPlaylist : Window
    {
        public EditRecordPlaylist()
        {
            InitializeComponent();
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        MusicDBEntities db = new MusicDBEntities();
        Playlist table = new Playlist();

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            StringBuilder errors = new StringBuilder();

            if (textboxName.Text.Length == 0) errors.AppendLine("Введите название плейлиста.");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }

            // Добвление трека
            table.Id = Data.ID;
            table.Name = textboxName.Text;
            table.Description = textBoxDescription.Text;

            try
            {
                db.SaveChanges();
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            table = db.Playlists.Find(Data.ID);
            textboxName.Text = Data.Name;
            textBoxDescription.Text = Data.Description;
        }
    }
}
