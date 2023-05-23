using System;
using System.Collections.Generic;
using System.Data.Entity;
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
    /// Логика взаимодействия для AddRecordTrack.xaml
    /// </summary>
    public partial class AddRecordTrack : Window
    {
        public AddRecordTrack()
        {
            InitializeComponent();
        }

        MusicDBEntities db = new MusicDBEntities();

        public bool isNewAlbum = true;
        public int newAlbumId;

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            if (isNewAlbum)
            {
                comboBox.Visibility = Visibility.Visible;
                labelAlbum.Visibility = Visibility.Visible;
            }
            else
            {
                comboBox.Visibility = Visibility.Hidden;
                labelAlbum.Visibility = Visibility.Hidden;
            }

            ComboBoxItem comboItem;
            // Заполнение выпадающих списков данными из базы данных
            foreach (var i in db.Albums)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = i.Id.ToString() + " " + i.Name;
                comboBox.Items.Add(comboItem);
            }

            foreach (var i in db.Genres)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = i.Id.ToString() + " " + i.Name;
                comboBoxGenre.Items.Add(comboItem);
            }
            if(isNewAlbum == false)
            {
                closeButton.Visibility = Visibility.Hidden;
            }
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            if (isNewAlbum)
            {
                if (comboBox.SelectedItem != null && comboBoxGenre.SelectedItem != null)
                {
                    Track table = new Track();
                    Genre genre = new Genre();

                    StringBuilder errors = new StringBuilder();

                    if (textboxName.Text.Length == 0) errors.AppendLine("Введите название трека.");
                    if (!int.TryParse(textBoxLength.Text, out int length)) errors.AppendLine("Введите длину трека в секундах.");

                    if (errors.Length > 0)
                    {
                        MessageBox.Show(errors.ToString());
                        return;
                    }

                    string[] findAlbums = comboBox.Text.Split(' ');
                    int albumId = int.Parse(findAlbums[0]);
                    string[] findGenre = comboBoxGenre.Text.Split(' ');
                    int genreId = int.Parse(findGenre[0]);

                    // Добaвление трека
                    table.Id = db.Tracks.Max(item => item.Id) + 1;
                    table.Name = textboxName.Text;
                    table.AlbumId = albumId;
                    table.TrackNumber = db.GetMaxTrackNumberForAlbum(int.Parse(findAlbums[0]));
                    table.Length = length;
                    table.Lyrics = textBoxLyrics.Text;
                    genre = db.Genres.FirstOrDefault(c => c.Id == genreId);

                    try
                    {
                        db.Tracks.Add(table);
                        genre.Tracks.Add(table);
                        db.SaveChanges();
                        Close();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message.ToString());
                    }
                }
                else
                {
                    MessageBox.Show("Выберите альбом и жанр!", "Ошибка!");
                }
            }
            else
            {
                if (comboBoxGenre.SelectedItem != null)
                {
                    Track table = new Track();
                    Genre genre = new Genre();

                    StringBuilder errors = new StringBuilder();

                    if (textboxName.Text.Length == 0) errors.AppendLine("Введите название трека.");
                    if (!int.TryParse(textBoxLength.Text, out int length)) errors.AppendLine("Введите длину трека в секундах.");

                    if (errors.Length > 0)
                    {
                        MessageBox.Show(errors.ToString());
                        return;
                    }

                    string[] findGenre = comboBoxGenre.Text.Split(' ');
                    int genreId = int.Parse(findGenre[0]);

                    // Добaвление трека
                    table.Id = db.Tracks.Max(item => item.Id) + 1;
                    table.Name = textboxName.Text;
                    table.AlbumId = newAlbumId;
                    table.TrackNumber = 1;
                    table.Length = length;
                    table.Lyrics = textBoxLyrics.Text;
                    genre = db.Genres.FirstOrDefault(c => c.Id == genreId);

                    try
                    {
                        db.Tracks.Add(table);
                        genre.Tracks.Add(table);
                        db.SaveChanges();
                        isNewAlbum = true;
                        Close();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message.ToString());
                    }
                }
                else
                {
                    MessageBox.Show("Выберите жанр!", "Ошибка!");
                }
            }

        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if(isNewAlbum == false)
            {
                e.Cancel = true;
                MessageBox.Show("Добавте хотя бы один трек.", "Ошибка!");
            }
            else e.Cancel = false;
        }
    }
}
