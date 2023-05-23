using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
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
    /// Логика взаимодействия для AddRecordAlbum.xaml
    /// </summary>
    public partial class AddRecordAlbum : Window
    {
        public AddRecordAlbum()
        {
            InitializeComponent();
        }

        MusicDBEntities db = MusicDBEntities.GetContext();
        DateTime? albumDate;

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            Album table = new Album();

            StringBuilder errors = new StringBuilder();

            if (comboBox.SelectedItem != null)
            {
                if (textboxName.Text.Length == 0) errors.AppendLine("Введите название Альбома.");
                if (comboBox.Text.Length == 0)
                    errors.AppendLine("Выберите исполнителя.");

                if (errors.Length > 0)
                {
                    MessageBox.Show(errors.ToString());
                    return;
                }

                string[] findArtists = comboBox.Text.Split(' ');

                DateTime selectedDate = albumDate ?? DateTime.MinValue;
                int albumId = db.Albums.Max(item => item.Id) + 1;
                table.Id = albumId;
                table.Name = textboxName.Text;
                table.ArtistId = int.Parse(findArtists[0]);
                table.ReleaseDate = selectedDate;
                table.Description = textBoxDescription.Text;

                try
                {
                    db.Albums.Add(table);
                    db.SaveChanges();

                    AddRecordTrack addTrack = new AddRecordTrack();
                    addTrack.isNewAlbum = false;
                    addTrack.newAlbumId = albumId;
                    addTrack.Owner = this;
                    addTrack.ShowDialog();

                    Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message.ToString());
                }
            }
            else
            {
                MessageBox.Show("Выберите исполнителя!", "Ошибка!");
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            ComboBoxItem comboItem;
            foreach (var str in db.Artists)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = str.Id.ToString() + " " + str.Name;
                comboBox.Items.Add(comboItem);
            }
        }

        private void datePicker_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            albumDate = datePicker.SelectedDate;
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}