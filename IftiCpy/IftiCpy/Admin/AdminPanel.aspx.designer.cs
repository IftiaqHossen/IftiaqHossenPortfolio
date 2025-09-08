using System.Web.UI;
using System.Web.UI.WebControls;

namespace IftiCpy.Admin
{
    /// <summary>
    /// Designer file for AdminPanel.aspx
    /// </summary>
    public partial class AdminPanel : Page
    {
        // Dashboard controls
        protected Literal WelcomeMessage;
        protected LinkButton btnLogout;
        protected Literal ActiveProjectsCount;
        protected Literal ActiveBlogsCount;
        protected Literal UnreadMessagesCount;
        protected Literal TotalMessagesCount;

        // Projects controls
        protected Button btnAddProject;
        protected GridView ProjectsGridView;

        // Blogs controls
        protected Button btnAddBlog;
        protected GridView BlogsGridView;

        // Messages controls
        protected Button btnRefreshMessages;
        protected GridView MessagesGridView;

        // Modal controls
        protected Literal ModalMessageName;
        protected Literal ModalMessageEmail;
        protected Literal ModalMessageSubject;
        protected Literal ModalMessageDate;
        protected Literal ModalMessageContent;
    }
}