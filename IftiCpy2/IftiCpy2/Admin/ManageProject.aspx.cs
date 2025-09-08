using System;
using System.Web.UI;
using IftiCpy.Data;

namespace IftiCpy.Admin
{
    public partial class ManageProject : Page
    {
        private PortfolioRepository _repository;
        private int? _projectId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["AdminUserId"] == null)
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            _repository = new PortfolioRepository();

            // Get project ID from query string
            if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int id))
            {
                _projectId = id;
            }

            if (!IsPostBack)
            {
                LoadProjectData();
            }
        }

        private void LoadProjectData()
        {
            if (_projectId.HasValue)
            {
                // Edit mode
                try
                {
                    var project = _repository.GetProjectById(_projectId.Value);
                    if (project != null)
                    {
                        PageTitle.Text = "Edit Project";
                        btnSave.Text = "Update Project";

                        // Populate form fields
                        txtTitle.Text = project.Title;
                        txtDescription.Text = project.Description;
                        txtImageUrl.Text = project.ImageUrl ?? "";
                        txtProjectUrl.Text = project.ProjectUrl ?? "";
                        txtTechStack.Text = project.TechStack ?? "";
                        chkIsActive.Checked = project.IsActive;
                    }
                    else
                    {
                        ShowError("Project not found.");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error loading project data.");
                    System.Diagnostics.Debug.WriteLine("Error loading project: " + ex.Message);
                }
            }
            else
            {
                // Add mode
                PageTitle.Text = "Add New Project";
                btnSave.Text = "Save Project";
                chkIsActive.Checked = true; // Default to active
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                var project = new Project
                {
                    Title = txtTitle.Text.Trim(),
                    Description = txtDescription.Text.Trim(),
                    ImageUrl = string.IsNullOrWhiteSpace(txtImageUrl.Text) ? null : txtImageUrl.Text.Trim(),
                    ProjectUrl = string.IsNullOrWhiteSpace(txtProjectUrl.Text) ? null : txtProjectUrl.Text.Trim(),
                    TechStack = string.IsNullOrWhiteSpace(txtTechStack.Text) ? null : txtTechStack.Text.Trim(),
                    IsActive = chkIsActive.Checked
                };

                if (_projectId.HasValue)
                {
                    // Update existing project
                    project.Id = _projectId.Value;
                    _repository.UpdateProject(project);
                    ShowSuccess("Project updated successfully!");
                }
                else
                {
                    // Create new project
                    var newId = _repository.InsertProject(project);
                    ShowSuccess("Project created successfully!");
                    
                    // Redirect to edit mode for the new project
                    Response.Redirect($"~/Admin/ManageProject.aspx?id={newId}");
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while saving the project. Please try again.");
                System.Diagnostics.Debug.WriteLine("Error saving project: " + ex.Message);
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminPanel.aspx");
        }

        protected void BtnBackToPanel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/AdminPanel.aspx");
        }

        private void ShowSuccess(string message)
        {
            SuccessMessage.Text = message;
            SuccessPanel.Visible = true;
            ErrorPanel.Visible = false;
        }

        private void ShowError(string message)
        {
            ErrorMessage.Text = message;
            ErrorPanel.Visible = true;
            SuccessPanel.Visible = false;
        }
    }
}