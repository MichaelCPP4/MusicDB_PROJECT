using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
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
    public partial class EditRecordTrack : Window
    {
        public EditRecordTrack()
        {
            InitializeComponent();
        }

        MusicDBEntities db = new MusicDBEntities();
        Track table = new Track();
        Genre genre = new Genre();
        Genre oldGenre = new Genre();


        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            table = db.Tracks.Find(Data.ID);
            textboxName.Text = Data.Name;
            textBoxLength.Text = Data.length.ToString();
            textBoxLyrics.Text = Data.Lyrics;

            genre = db.Tracks
    .Where(t => t.Id == Data.ID)
    .Select(t => t.Genres.FirstOrDefault())
    .SingleOrDefault();
            oldGenre = genre;
            /*
                        string query = @"
                SELECT G.Name
                FROM Genres G
                INNER JOIN TrackGenres TG ON G.Id = TG.GenreId
                WHERE TG.TrackId = @TrackId";

                        var genres = db.Database.SqlQuery<string>(query, new SqlParameter("TrackId", Data.ID));*/

            ComboBoxItem comboItem;

            foreach (var i in db.Genres)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = i.Id.ToString() + " " + i.Name;
                comboBoxGenre.Items.Add(comboItem);
            }

            //comboBoxGenre.SelectedIndex = oldGenre.Id-1;
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            if (comboBoxGenre.SelectedItem != null)
            {
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

                try
                {
                    table.Name = textboxName.Text;
                    table.TrackNumber = Data.trackNumber;
                    table.Length = length;
                    table.Lyrics = textBoxLyrics.Text;
                    genre = db.Genres.FirstOrDefault(c => c.Id == genreId);

                    table.Genres.Remove(oldGenre);
                    table.Genres.Add(genre);

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
                MessageBox.Show("Выверите жанр!", "Ошибка!");
            }
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
