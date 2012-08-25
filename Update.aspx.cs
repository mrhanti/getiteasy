using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;

public partial class Update : System.Web.UI.Page
{
    MySqlConnection dbConnection = null;
    MySqlCommand slctTopics = null;
    MySqlCommand updtTopicsNumberOfVideos = null;

    MySqlDataReader dReaderTopics = null;

    ArrayList topics_ids = null;
    int counter = 0;
    int i = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        topics_ids = new ArrayList();
        
        dbConnection = new MySqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
        dbConnection.Open();

        slctTopics = new MySqlCommand("SELECT t_id FROM topics", dbConnection);
        dReaderTopics = slctTopics.ExecuteReader();

        while (dReaderTopics.Read())
        {
            topics_ids.Add(dReaderTopics[0].ToString());
            counter++;            
        }

        dReaderTopics.Close();
        slctTopics.Dispose();        

        while (i < counter)
        {
            updtTopicsNumberOfVideos = new MySqlCommand("UPDATE topics SET t_nb_videos=(SELECT count(*) FROM videos WHERE t_id=" + topics_ids[i].ToString() + ") WHERE t_id=" + topics_ids[i].ToString(), dbConnection);
            updtTopicsNumberOfVideos.ExecuteNonQuery();
            updtTopicsNumberOfVideos.Dispose();
            i++;
        }
    }
}