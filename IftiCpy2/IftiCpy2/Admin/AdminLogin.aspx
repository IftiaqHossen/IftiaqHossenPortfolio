<%@ Page Title="Admin Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="IftiCpy.Admin.AdminLogin" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card mt-5">
                    <div class="card-header">
                        <h3 class="text-center">Admin Login</h3>
                    </div>
                    <div class="card-body">
                        <asp:Panel ID="ErrorPanel" runat="server" CssClass="alert alert-danger" Visible="false">
                            <asp:Literal ID="ErrorMessage" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="form-group mb-3">
                            <label for="txtUsername">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username" required></asp:TextBox>
                        </div>
                        
                        <div class="form-group mb-3">
                            <label for="txtPassword">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter password" required></asp:TextBox>
                        </div>
                        
                        <div class="text-center">
                            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary w-100" OnClick="BtnLogin_Click" />
                        </div>
                    </div>
                    <div class="card-footer text-center">
                        <small class="text-muted">Portfolio Admin Panel</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }
    </style>
</asp:Content>