using System;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace QuarkDebloatGUI
{
    public partial class MainForm : Form
    {
        private Process psProcess;
        private bool isProcessRunning = false;

        public MainForm()
        {
            InitializeComponent();
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Size = new System.Drawing.Size(900, 650);
            this.Text = "Quark11 - Windows 11 Debloat Tool v1.0.0";
            this.Icon = SystemIcons.Application;
            InitializeUI();
            CheckSystemRequirements();
        }

        private void InitializeUI()
        {
            // Main container
            TableLayoutPanel mainLayout = new TableLayoutPanel()
            {
                Dock = DockStyle.Fill,
                RowCount = 4,
                ColumnCount = 1,
                Padding = new Padding(15),
                AutoSize = true
            };

            // Header
            Label titleLabel = new Label()
            {
                Text = "🔧 Quark11 Windows 11 Debloat Tool",
                Font = new System.Drawing.Font("Segoe UI", 16, System.Drawing.FontStyle.Bold),
                ForeColor = System.Drawing.Color.FromArgb(0, 120, 215),
                AutoSize = true,
                Margin = new Padding(0, 0, 0, 10)
            };

            Label versionLabel = new Label()
            {
                Text = "v1.0.0 | Powered by Quark11 & MassGrave.dev",
                Font = new System.Drawing.Font("Segoe UI", 9),
                ForeColor = System.Drawing.Color.Gray,
                AutoSize = true,
                Margin = new Padding(0, 0, 0, 15)
            };

            Panel headerPanel = new Panel() { AutoSize = true };
            headerPanel.Controls.Add(versionLabel);
            headerPanel.Controls.Add(titleLabel);

            // Options Panel
            GroupBox optionsGroup = new GroupBox()
            {
                Text = "Debloat Options",
                AutoSize = true,
                Dock = DockStyle.Top,
                Padding = new Padding(15)
            };

            FlowLayoutPanel optionsLayout = new FlowLayoutPanel()
            {
                FlowDirection = FlowDirection.TopDown,
                AutoSize = true,
                WrapContents = false
            };

            CheckBox removeOneDrive = new CheckBox() { Text = "Remove OneDrive", AutoSize = true, Margin = new Padding(0, 5, 0, 5), Tag = "OneDrive" };
            CheckBox removeEdge = new CheckBox() { Text = "Remove Microsoft Edge", AutoSize = true, Margin = new Padding(0, 5, 0, 5), Tag = "Edge" };
            CheckBox removeGamePass = new CheckBox() { Text = "Remove Xbox Game Pass", AutoSize = true, Margin = new Padding(0, 5, 0, 5), Tag = "GamePass" };
            CheckBox removeCopilot = new CheckBox() { Text = "Remove Windows Copilot", AutoSize = true, Margin = new Padding(0, 5, 0, 5), Tag = "Copilot" };
            CheckBox createRestorePoint = new CheckBox() { Text = "✓ Create System Restore Point (Recommended)", AutoSize = true, Margin = new Padding(0, 5, 0, 5), Checked = true, Tag = "RestorePoint" };
            CheckBox cleanupAll = new CheckBox() { Text = "🔥 Aggressive Cleanup (All of above)", AutoSize = true, Margin = new Padding(0, 10, 0, 5), Tag = "CleanupAll", Font = new System.Drawing.Font("Segoe UI", 9, System.Drawing.FontStyle.Bold) };

            optionsLayout.Controls.Add(removeOneDrive);
            optionsLayout.Controls.Add(removeEdge);
            optionsLayout.Controls.Add(removeGamePass);
            optionsLayout.Controls.Add(removeCopilot);
            optionsLayout.Controls.Add(createRestorePoint);
            optionsLayout.Controls.Add(cleanupAll);
            optionsGroup.Controls.Add(optionsLayout);

            // Log output
            RichTextBox logOutput = new RichTextBox()
            {
                Dock = DockStyle.Fill,
                ReadOnly = true,
                Font = new System.Drawing.Font("Courier New", 9),
                BackColor = System.Drawing.Color.FromArgb(30, 30, 30),
                ForeColor = System.Drawing.Color.LimeGreen,
                Margin = new Padding(0, 10, 0, 10)
            };
            logOutput.Name = "LogOutput";

            // Progress bar
            ProgressBar progressBar = new ProgressBar()
            {
                Dock = DockStyle.Top,
                Height = 20,
                Style = ProgressBarStyle.Marquee,
                Visible = false,
                Margin = new Padding(0, 10, 0, 10)
            };
            progressBar.Name = "ProgressBar";

            // Buttons panel
            FlowLayoutPanel buttonsPanel = new FlowLayoutPanel()
            {
                FlowDirection = FlowDirection.LeftToRight,
                AutoSize = true,
                WrapContents = false,
                Margin = new Padding(0, 10, 0, 0)
            };

            Button debloatBtn = new Button()
            {
                Text = "▶ Start Debloat",
                Width = 150,
                Height = 40,
                Font = new System.Drawing.Font("Segoe UI", 10, System.Drawing.FontStyle.Bold),
                BackColor = System.Drawing.Color.FromArgb(0, 120, 215),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat,
                Margin = new Padding(0, 0, 10, 0)
            };
            debloatBtn.Click += (s, e) => StartDebloat(optionsGroup);

            Button downloadBtn = new Button()
            {
                Text = "⬇ Download Win11 (MassGrave)",
                Width = 200,
                Height = 40,
                Font = new System.Drawing.Font("Segoe UI", 10, System.Drawing.FontStyle.Bold),
                BackColor = System.Drawing.Color.FromArgb(40, 167, 69),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat,
                Margin = new Padding(0, 0, 10, 0)
            };
            downloadBtn.Click += DownloadWindows11;

            Button stopBtn = new Button()
            {
                Text = "⏹ Stop",
                Width = 100,
                Height = 40,
                Font = new System.Drawing.Font("Segoe UI", 10, System.Drawing.FontStyle.Bold),
                BackColor = System.Drawing.Color.FromArgb(220, 53, 69),
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat,
                Enabled = false,
                Margin = new Padding(0, 0, 10, 0)
            };
            stopBtn.Name = "StopBtn";
            stopBtn.Click += (s, e) => StopProcess();

            Button clearBtn = new Button()
            {
                Text = "🗑 Clear Log",
                Width = 100,
                Height = 40,
                Font = new System.Drawing.Font("Segoe UI", 10),
                FlatStyle = FlatStyle.Flat,
                Margin = new Padding(0, 0, 10, 0)
            };
            clearBtn.Click += (s, e) => logOutput.Clear();

            Button restoreBtn = new Button()
            {
                Text = "↶ Restore",
                Width = 100,
                Height = 40,
                Font = new System.Drawing.Font("Segoe UI", 10),
                FlatStyle = FlatStyle.Flat
            };
            restoreBtn.Click += RestoreSystem;

            buttonsPanel.Controls.Add(debloatBtn);
            buttonsPanel.Controls.Add(downloadBtn);
            buttonsPanel.Controls.Add(stopBtn);
            buttonsPanel.Controls.Add(clearBtn);
            buttonsPanel.Controls.Add(restoreBtn);

            // Status bar
            Label statusLabel = new Label()
            {
                Text = "Status: Ready",
                AutoSize = true,
                Font = new System.Drawing.Font("Segoe UI", 9),
                ForeColor = System.Drawing.Color.Gray,
                Margin = new Padding(0, 10, 0, 0)
            };
            statusLabel.Name = "StatusLabel";

            // Add to main layout
            mainLayout.Controls.Add(headerPanel, 0, 0);
            mainLayout.Controls.Add(optionsGroup, 0, 0);
            Panel logPanel = new Panel() { Dock = DockStyle.Fill };
            logPanel.Controls.Add(logOutput);
            logPanel.Controls.Add(progressBar);
            mainLayout.Controls.Add(logPanel, 0, 1);
            mainLayout.Controls.Add(buttonsPanel, 0, 2);
            mainLayout.Controls.Add(statusLabel, 0, 3);

            this.Controls.Add(mainLayout);
        }

        private void CheckSystemRequirements()
        {
            RichTextBox log = this.Controls[0].Controls.OfType<Panel>().FirstOrDefault()?.Controls.OfType<RichTextBox>().FirstOrDefault();
            if (log == null) return;

            log.AppendText("=== System Requirements Check ===\n", System.Drawing.Color.Cyan);

            bool isAdmin = IsAdministrator();
            log.AppendText($"Administrator: {(isAdmin ? "✓ Yes" : "✗ No")}\n", isAdmin ? System.Drawing.Color.LimeGreen : System.Drawing.Color.Red);

            if (!isAdmin)
            {
                log.AppendText("\n⚠ WARNING: Please run as Administrator!\n", System.Drawing.Color.Yellow);
                MessageBox.Show("This application requires Administrator privileges.\n\nPlease restart as Administrator.", "Administrator Required", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                Environment.Exit(0);
            }

            log.AppendText($"OS: {Environment.OSVersion.VersionString}\n", System.Drawing.Color.White);
            bool psAvailable = File.Exists(Environment.ExpandEnvironmentVariables("%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"));
            log.AppendText($"PowerShell: {(psAvailable ? "✓ Available" : "✗ Not Found")}\n", psAvailable ? System.Drawing.Color.LimeGreen : System.Drawing.Color.Red);
            log.AppendText("===================================\n\n", System.Drawing.Color.Cyan);
        }

        private bool IsAdministrator()
        {
            System.Security.Principal.WindowsIdentity identity = System.Security.Principal.WindowsIdentity.GetCurrent();
            System.Security.Principal.WindowsPrincipal principal = new System.Security.Principal.WindowsPrincipal(identity);
            return principal.IsInRole(System.Security.Principal.WindowsBuiltInRole.Administrator);
        }

        private void StartDebloat(GroupBox optionsGroup)
        {
            if (isProcessRunning)
            {
                MessageBox.Show("A process is already running!", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            RichTextBox log = this.Controls[0].Controls.OfType<Panel>().FirstOrDefault()?.Controls.OfType<RichTextBox>().FirstOrDefault();
            ProgressBar progress = this.Controls[0].Controls.OfType<ProgressBar>().FirstOrDefault();
            Button stopBtn = this.Controls.Find("StopBtn", true).FirstOrDefault() as Button;
            Label statusLabel = this.Controls.Find("StatusLabel", true).FirstOrDefault() as Label;

            if (log == null || progress == null) return;

            string scriptPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..\\..\\..\\scripts\\debloat-windows11.ps1");
            if (!File.Exists(scriptPath))
            {
                scriptPath = "debloat-windows11.ps1";
            }

            string parameters = "";
            foreach (Control ctrl in optionsGroup.Controls[0].Controls)
            {
                if (ctrl is CheckBox cb && cb.Checked && cb.Tag != null)
                {
                    string tag = cb.Tag.ToString();
                    if (tag == "OneDrive") parameters += " -RemoveOnedrive";
                    else if (tag == "Edge") parameters += " -RemoveEdge";
                    else if (tag == "GamePass") parameters += " -RemoveGamePass";
                    else if (tag == "Copilot") parameters += " -RemoveCopilot";
                    else if (tag == "CleanupAll") parameters += " -CleanupAll";
                }
            }

            log.AppendText($"[{DateTime.Now:HH:mm:ss}] Starting debloat process...\n", System.Drawing.Color.Cyan);
            log.AppendText($"Parameters: {(string.IsNullOrEmpty(parameters) ? "Default" : parameters)}\n\n", System.Drawing.Color.Yellow);

            progress.Visible = true;
            stopBtn.Enabled = true;
            isProcessRunning = true;
            statusLabel.Text = "Status: Running...";
            statusLabel.ForeColor = System.Drawing.Color.Orange;

            Task.Run(() => ExecutePowerShellScript(scriptPath, parameters, log, progress, stopBtn, statusLabel));
        }

        private void ExecutePowerShellScript(string scriptPath, string parameters, RichTextBox log, ProgressBar progress, Button stopBtn, Label statusLabel)
        {
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo()
                {
                    FileName = "powershell.exe",
                    Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{scriptPath}\"{parameters}",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                psProcess = Process.Start(psi);
                string output = psProcess.StandardOutput.ReadToEnd();
                string error = psProcess.StandardError.ReadToEnd();

                psProcess.WaitForExit();

                this.Invoke((MethodInvoker)(() =>
                {
                    log.AppendText($"{output}\n", System.Drawing.Color.LimeGreen);
                    if (!string.IsNullOrEmpty(error))
                        log.AppendText($"\nErrors:\n{error}\n", System.Drawing.Color.Red);

                    log.AppendText($"\n[{DateTime.Now:HH:mm:ss}] Debloat process completed.\n", System.Drawing.Color.Cyan);
                    progress.Visible = false;
                    stopBtn.Enabled = false;
                    isProcessRunning = false;
                    statusLabel.Text = "Status: Complete";
                    statusLabel.ForeColor = System.Drawing.Color.LimeGreen;

                    MessageBox.Show("Debloat process completed!\n\nPlease restart your computer for all changes to take effect.", "Complete", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }));
            }
            catch (Exception ex)
            {
                this.Invoke((MethodInvoker)(() =>
                {
                    log.AppendText($"\nError: {ex.Message}\n", System.Drawing.Color.Red);
                    progress.Visible = false;
                    stopBtn.Enabled = false;
                    isProcessRunning = false;
                    statusLabel.Text = "Status: Error";
                    statusLabel.ForeColor = System.Drawing.Color.Red;
                }));
            }
        }

        private void DownloadWindows11(object sender, EventArgs e)
        {
            RichTextBox log = this.Controls[0].Controls.OfType<Panel>().FirstOrDefault()?.Controls.OfType<RichTextBox>().FirstOrDefault();
            if (log == null) return;

            log.AppendText($"[{DateTime.Now:HH:mm:ss}] Opening MassGrave.dev...\n", System.Drawing.Color.Cyan);
            try
            {
                System.Diagnostics.Process.Start("https://massgrave.dev");
                log.AppendText("✓ Browser opened to MassGrave.dev\n", System.Drawing.Color.LimeGreen);
            }
            catch (Exception ex)
            {
                log.AppendText($"Error opening browser: {ex.Message}\n", System.Drawing.Color.Red);
            }
        }

        private void StopProcess()
        {
            RichTextBox log = this.Controls[0].Controls.OfType<Panel>().FirstOrDefault()?.Controls.OfType<RichTextBox>().FirstOrDefault();
            if (psProcess != null && !psProcess.HasExited)
            {
                psProcess.Kill();
                if (log != null)
                    log.AppendText($"[{DateTime.Now:HH:mm:ss}] Process stopped by user.\n", System.Drawing.Color.Yellow);
                isProcessRunning = false;
            }
        }

        private void RestoreSystem(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show(
                "This will restore your system to a previous restore point.\n\nDo you want to continue?",
                "System Restore",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question
            );

            if (result == DialogResult.Yes)
            {
                try
                {
                    ProcessStartInfo psi = new ProcessStartInfo()
                    {
                        FileName = "rstrui.exe",
                        UseShellExecute = true,
                        CreateNoWindow = false
                    };
                    Process.Start(psi);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Error opening System Restore: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }

    static class RichTextBoxExtensions
    {
        public static void AppendText(this RichTextBox rtb, string text, System.Drawing.Color color)
        {
            rtb.SelectionStart = rtb.TextLength;
            rtb.SelectionLength = 0;
            rtb.SelectionColor = color;
            rtb.AppendText(text);
            rtb.SelectionColor = rtb.ForeColor;
        }
    }
}
