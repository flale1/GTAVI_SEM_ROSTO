// Jogar-VIctory: janela simples para abrir o VIctory sem digitar comandos.
// So chama os scripts do pacote (Preparar-Shaders.cmd, Play-VIctory.cmd, ...), com VICTORY_GAME_DIR definido.
// GPL-3.0-or-later, como o VIctory. Compilar:
//   C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /nologo /target:winexe /out:Jogar-VIctory.exe launcher\Jogar-VIctory.cs
using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

static class JogarVIctory
{
    static string pasta = AppDomain.CurrentDomain.BaseDirectory;
    static string ini = Path.Combine(pasta, "Jogar-VIctory.ini");
    static string jogo;
    static Label status;

    [STAThread]
    static void Main()
    {
        Application.EnableVisualStyles();
        jogo = AcharJogo();

        var f = new Form { Text = "VIctory", Width = 440, Height = 430, FormBorderStyle = FormBorderStyle.FixedDialog, MaximizeBox = false, StartPosition = FormStartPosition.CenterScreen };
        var t = new Label { Text = "VIctory: Series S / pouca RAM", Font = new Font("Segoe UI", 13, FontStyle.Bold), Left = 20, Top = 15, Width = 390, Height = 30 };
        status = new Label { Left = 20, Top = 50, Width = 390, Height = 45, Font = new Font("Segoe UI", 9) };
        f.Controls.Add(t);
        f.Controls.Add(status);
        AtualizarStatus();

        int y = 100;
        Botao(f, ref y, "Escolher a pasta do jogo...", delegate { EscolherJogo(); }, false);
        Botao(f, ref y, "1. Preparar shaders (primeira vez e a cada versao)", delegate { Rodar("Preparar-Shaders.cmd", null); }, true);
        Botao(f, ref y, "2. Jogar (Series S, recomendado)", delegate { Rodar("Play-VIctory.cmd", null); }, true);
        Botao(f, ref y, "Jogar no Series X (32 GB de RAM ou mais)", delegate { Rodar("Play-SeriesX.cmd", null); }, true);
        Botao(f, ref y, "Aquecer o driver (depois de jogar uma vez)", delegate { Rodar("Aquecer-Driver.cmd", null); }, true);
        Botao(f, ref y, "Diagnostico (joga e gera um zip com o log)", delegate { Rodar("Diagnostico.ps1", null); }, true);
        Botao(f, ref y, "Abrir a pasta dos saves", delegate { AbrirSaves(); }, false);

        Application.Run(f);
    }

    static void Botao(Form f, ref int y, string texto, EventHandler acao, bool precisaJogo)
    {
        var b = new Button { Text = texto, Left = 20, Top = y, Width = 390, Height = 34, Font = new Font("Segoe UI", 9.5f) };
        b.Click += delegate (object s, EventArgs e)
        {
            if (precisaJogo && jogo == null) { EscolherJogo(); if (jogo == null) return; }
            acao(s, e);
        };
        f.Controls.Add(b);
        y += 40;
    }

    static bool EhJogo(string p) { return p != null && File.Exists(Path.Combine(p, "game_scarlett_master.exe")); }

    static string AcharJogo()
    {
        try
        {
            if (File.Exists(ini))
            {
                string salvo = File.ReadAllText(ini).Trim();
                if (EhJogo(salvo)) return salvo;
            }
        }
        catch { }
        string aqui = pasta.TrimEnd('\\');
        if (EhJogo(aqui)) return aqui;
        string pai = Path.GetDirectoryName(aqui);
        if (EhJogo(pai)) return pai;
        string env = Environment.GetEnvironmentVariable("VICTORY_GAME_DIR");
        if (EhJogo(env)) return env;
        return null;
    }

    static void EscolherJogo()
    {
        using (var d = new FolderBrowserDialog { Description = "Escolha a pasta do seu dump, a que tem game_scarlett_master.exe" })
        {
            if (d.ShowDialog() != DialogResult.OK) return;
            if (!EhJogo(d.SelectedPath))
            {
                MessageBox.Show("Essa pasta nao tem game_scarlett_master.exe.", "VIctory", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            jogo = d.SelectedPath;
            try { File.WriteAllText(ini, jogo); } catch { }
            AtualizarStatus();
        }
    }

    static void AtualizarStatus()
    {
        if (!File.Exists(Path.Combine(pasta, "victory.exe")))
            status.Text = "victory.exe nao esta nesta pasta. Extraia o pacote inteiro.";
        else if (jogo == null)
            status.Text = "Jogo nao encontrado. Clique em \"Escolher a pasta do jogo\".";
        else
            status.Text = "Jogo: " + jogo;
    }

    static void Rodar(string script, string extra)
    {
        string caminho = Path.Combine(pasta, script);
        if (!File.Exists(caminho))
        {
            MessageBox.Show("Nao achei " + script + " na pasta do pacote.", "VIctory", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }
        var psi = new ProcessStartInfo { WorkingDirectory = pasta, UseShellExecute = false };
        if (script.EndsWith(".ps1"))
        {
            psi.FileName = "powershell.exe";
            psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + caminho + "\"";
        }
        else
        {
            psi.FileName = "cmd.exe";
            psi.Arguments = "/k \"\"" + caminho + "\"\"";
        }
        psi.EnvironmentVariables["VICTORY_GAME_DIR"] = jogo;
        try { Process.Start(psi); }
        catch (Exception e) { MessageBox.Show(e.Message, "VIctory", MessageBoxButtons.OK, MessageBoxIcon.Error); }
    }

    static void AbrirSaves()
    {
        string s = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"victory\data\7952987A\saves");
        if (!Directory.Exists(s)) s = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "victory");
        if (!Directory.Exists(s)) { MessageBox.Show("Ainda nao ha saves: jogue uma vez.", "VIctory"); return; }
        Process.Start("explorer.exe", "\"" + s + "\"");
    }
}
