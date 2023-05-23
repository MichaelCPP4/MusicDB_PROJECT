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
    /// Логика взаимодействия для AddRecordArtist.xaml
    /// </summary>
    public partial class EditRecordArtist : Window
    {
        public EditRecordArtist()
        {
            InitializeComponent();
        }

        MusicDBEntities db = MusicDBEntities.GetContext();
        Artist table = new Artist();

        private void Add_Click(object sender, RoutedEventArgs e)
        {
            StringBuilder errors = new StringBuilder();

            //if (!int.TryParse(IDProduct.Text, out int id)) errors.AppendLine("Введите ID продукта.");
            if (textboxName.Text.Length == 0) errors.AppendLine("Введите имя или название группы.");
            if (textBoxCountry.Text.Length == 0) errors.AppendLine("Введите страну исполнителя.");
            //if (textBoxDescription.Text.Length == 0) errors.AppendLine("Введите биографию");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString());
                return;
            }


            try
            {
                table.Id = db.Artists.FirstOrDefault(a => a.Name == Data.Name).Id;
                table.Name = textboxName.Text;
                table.Country = textBoxCountry.Text;
                table.Description = textBoxDescription.Text;
                db.SaveChanges();
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            table = db.Artists.Find(Data.ID);
            textboxName.Text = Data.Name;
            textBoxCountry.Text = Data.Country;
            textBoxDescription.Text = db.Artists.FirstOrDefault(a => a.Name == Data.Name).Description;
        }
    }
}
