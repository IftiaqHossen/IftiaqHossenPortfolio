using System;
using System.Web.UI;
using Newtonsoft.Json;
using IftiCpy.Data;

namespace IftiCpy
{
    public partial class Projects : Page
    {
        private PortfolioRepository _repository;

        protected void Page_Load(object sender, EventArgs e)
        {
            _repository = new PortfolioRepository();

            // Set response type to JSON
            Response.ContentType = "application/json";
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);

            try
            {
                // Get active projects from database
                var projects = _repository.GetActiveProjects();

                // Convert to JSON and send response
                string json = JsonConvert.SerializeObject(projects, Formatting.Indented);
                Response.Write(json);
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                Response.Write(JsonConvert.SerializeObject(new 
                { 
                    error = "Unable to load projects", 
                    message = ex.Message 
                }));
                System.Diagnostics.Debug.WriteLine("Projects.aspx error: " + ex.Message);
            }

            Response.End();
        }
    }
}