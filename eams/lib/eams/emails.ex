defmodule Eams.Emails do
  @moduledoc """
  Email service for sending system emails.
  """

  import Swoosh.Email
  alias Eams.Mailer

  @from_email "benbrixlo@gmail.com"
  @from_name "Enterprise AMS"

  @doc """
  Sends welcome email to newly created supervisor.
  """
  def send_supervisor_welcome_email(to_email, full_name, temp_password, _super_supervisor_id) do
    new()
    |> to({full_name, to_email})
    |> from({@from_name, @from_email})
    |> subject("Welcome to Enterprise Attachment Management System")
    |> html_body("""
    <html>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
        <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
          <h2 style="color: #5B21B6;">Welcome to Enterprise AMS</h2>

          <p>Hi #{full_name},</p>

          <p>You've been assigned as a <strong>Supervisor</strong> in our Attachment Management System.</p>

          <div style="background-color: #F3F4F6; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h3 style="margin-top: 0;">Your Login Credentials</h3>
            <p><strong>Email:</strong> #{to_email}</p>
            <p><strong>Temporary Password:</strong> <code style="background-color: #E5E7EB; padding: 2px 6px; border-radius: 3px;">#{temp_password}</code></p>
          </div>

          <p>
            <a href="https://yourcompany.com/login"
               style="display: inline-block; background-color: #5B21B6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; margin: 10px 0;">
              Login Now
            </a>
          </p>

          <p><strong>Important:</strong> You'll be required to change your password on first login.</p>

          <h3>Your Responsibilities Include:</h3>
          <ul>
            <li>Managing attachees in your assigned team</li>
            <li>Assigning and reviewing tasks</li>
            <li>Providing feedback and evaluations</li>
            <li>Tracking team performance</li>
          </ul>

          <p>If you have any questions, please contact your Super Supervisor.</p>

          <p style="margin-top: 30px; color: #666; font-size: 14px;">
            Best regards,<br>
            Enterprise AMS Team
          </p>
        </div>
      </body>
    </html>
    """)
    |> Mailer.deliver()
  end

  @doc """
  Sends welcome email to newly created attachee.
  """
  def send_attachee_welcome_email(to_email, full_name, temp_password, _supervisor_id) do
    new()
    |> to({full_name, to_email})
    |> from({@from_name, @from_email})
    |> subject("Welcome to Your Attachment Program")
    |> html_body("""
    <html>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
        <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
          <h2 style="color: #5B21B6;">Welcome to Your Attachment Program! 🎓</h2>

          <p>Hi #{full_name},</p>

          <p>Welcome aboard! Your supervisor has created an account for you in our Attachment Management System.</p>

          <div style="background-color: #F3F4F6; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h3 style="margin-top: 0;">Your Login Credentials</h3>
            <p><strong>Email:</strong> #{to_email}</p>
            <p><strong>Temporary Password:</strong> <code style="background-color: #E5E7EB; padding: 2px 6px; border-radius: 3px;">#{temp_password}</code></p>
          </div>

          <p>
            <a href="https://yourcompany.com/login"
               style="display: inline-block; background-color: #5B21B6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; margin: 10px 0;">
              Access Your Dashboard
            </a>
          </p>

          <p><strong>Security Note:</strong> Please change your password immediately after logging in.</p>

          <h3>What You Can Do:</h3>
          <ul>
            <li>View and manage your assigned tasks</li>
            <li>Track your projects and deadlines</li>
            <li>Submit work for review</li>
            <li>View feedback and evaluations</li>
            <li>Monitor your progress</li>
          </ul>

          <p>Make the most of this opportunity and don't hesitate to reach out to your supervisor if you need help!</p>

          <p style="margin-top: 30px; color: #666; font-size: 14px;">
            Best regards,<br>
            Enterprise AMS Team
          </p>
        </div>
      </body>
    </html>
    """)
    |> Mailer.deliver()
  end

  @doc """
  Sends password reset email.
  """
  def send_password_reset_email(to_email, full_name, temp_password) do
    new()
    |> to({full_name, to_email})
    |> from({@from_name, @from_email})
    |> subject("Your Password Has Been Reset")
    |> html_body("""
    <html>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
        <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
          <h2 style="color: #5B21B6;">Password Reset</h2>

          <p>Hi #{full_name},</p>

          <p>Your password has been reset by your administrator.</p>

          <div style="background-color: #F3F4F6; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <h3 style="margin-top: 0;">Your New Temporary Password</h3>
            <p><code style="background-color: #E5E7EB; padding: 2px 6px; border-radius: 3px; font-size: 16px;">#{temp_password}</code></p>
          </div>

          <p>
            <a href="https://yourcompany.com/login"
               style="display: inline-block; background-color: #5B21B6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; margin: 10px 0;">
              Login Now
            </a>
          </p>

          <p><strong>Important:</strong> You must change this password when you log in.</p>

          <p style="margin-top: 30px; color: #666; font-size: 14px;">
            If you didn't request this reset, please contact your administrator immediately.
          </p>

          <p style="color: #666; font-size: 14px;">
            Best regards,<br>
            Enterprise AMS Team
          </p>
        </div>
      </body>
    </html>
    """)
    |> Mailer.deliver()
  end
end
