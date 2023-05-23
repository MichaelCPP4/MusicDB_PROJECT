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
    public partial class EditRecordAlbum : Window
    {
        public EditRecordAlbum()
        {
            InitializeComponent();
        }

        MusicDBEntities db = MusicDBEntities.GetContext();
        Album table = new Album();
        DateTime? albumDate;
        int artistID;
        int Id;

        private void Add_Click(object sender, RoutedEventArgs e)
        {

            StringBuilder errors = new StringBuilder();

            //if (!int.TryParse(IDProduct.Text, out int id)) errors.AppendLine("Введите ID продукта.");
            if (textboxName.Text.Length == 0) errors.AppendLine("Введите название Альбома.");
            if (comboBox.Text.Length == 0)
                errors.AppendLine("Выберите исполнителя.");
            //if (textBoxCountry.Text.Length == 0) errors.AppendLine("Введите страну исполнителя.");
            //if (textBoxDescription.Text.Length == 0) errors.AppendLine("Введите биографию");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }

            string[] findArtists = comboBox.Text.Split(' ');

            //DateTime? selectedDateNullable = albumDate.SelectedDate;
            DateTime selectedDate = albumDate ?? DateTime.MinValue;
            int albumId = Id;
            table.Id = albumId;
            table.Name = textboxName.Text;
            table.ArtistId = int.Parse(findArtists[0]);
            table.ReleaseDate = selectedDate;
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
            table = db.Albums.Find(Data.ID);
            textboxName.Text = Data.Name;
            datePicker.SelectedDate = Data.releaseYear;
            textBoxDescription.Text = Data.Description;
            artistID = (int)table.ArtistId;
            Id = table.Id;

            ComboBoxItem comboItem;
            foreach (var str in db.Artists)
            {
                comboItem = new ComboBoxItem();
                comboItem.Content = str.Id.ToString() + " " + str.Name;
                comboBox.Items.Add(comboItem);
            }

            comboBox.SelectedIndex = artistID-1;
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
