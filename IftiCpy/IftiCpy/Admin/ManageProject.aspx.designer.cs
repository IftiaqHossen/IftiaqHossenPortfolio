using System.Web.UI;
using System.Web.UI.WebControls;

namespace IftiCpy.Admin
{
    /// <summary>
    /// Designer file for ManageProject.aspx
    /// </summary>
    public partial class ManageProject : Page
    {
        protected Literal PageTitle;
        protected LinkButton btnBackToPanel;
        
        protected Panel SuccessPanel;
        protected Literal SuccessMessage;
        protected Panel ErrorPanel;
        protected Literal ErrorMessage;
        
        protected TextBox txtTitle;
        protected RequiredFieldValidator rfvTitle;
        
        protected TextBox txtDescription;
        protected RequiredFieldValidator rfvDescription;
        
        protected TextBox txtImageUrl;
        protected TextBox txtProjectUrl;
        protected TextBox txtTechStack;
        protected CheckBox chkIsActive;
        
        protected Button btnCancel;
        protected Button btnSave;
    }
}