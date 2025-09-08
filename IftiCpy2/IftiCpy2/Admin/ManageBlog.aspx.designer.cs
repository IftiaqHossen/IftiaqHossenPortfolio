using System.Web.UI;
using System.Web.UI.WebControls;

namespace IftiCpy.Admin
{
    /// <summary>
    /// Designer file for ManageBlog.aspx
    /// </summary>
    public partial class ManageBlog : Page
    {
        protected Literal PageTitle;
        protected LinkButton btnBackToPanel;
        
        protected Panel SuccessPanel;
        protected Literal SuccessMessage;
        protected Panel ErrorPanel;
        protected Literal ErrorMessage;
        
        protected TextBox txtTitle;
        protected RequiredFieldValidator rfvTitle;
        
        protected TextBox txtSlug;
        
        protected TextBox txtDescription;
        protected RequiredFieldValidator rfvDescription;
        
        protected TextBox txtContent;
        protected RequiredFieldValidator rfvContent;
        
        protected TextBox txtImageUrl;
        protected DropDownList ddlPlatform;
        protected TextBox txtCustomPlatform;
        protected CheckBox chkIsActive;
        
        protected Button btnCancel;
        protected Button btnSave;
    }
}