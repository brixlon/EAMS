defmodule EamsWeb.ForgotPasswordLive do
  use EamsWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{"email" => ""}, as: :user))}
  end

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <!-- Left Side - Image Slider with Text Overlay -->
      <div class="hidden lg:flex lg:w-1/2 relative overflow-hidden">
        <!-- Sliding Background Images -->
        <div class="absolute inset-0">
          <div class="slide-container">
            <div class="slide">
              <img
                src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=1200&auto=format&fit=crop&q=80"
                alt="Team collaboration"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="slide">
              <img
                src="https://images.unsplash.com/photo-1553877522-43269d4ea984?w=1200&auto=format&fit=crop&q=80"
                alt="Professional workplace"
                class="w-full h-full object-cover"
              />
            </div>
            <div class="slide">
              <img
                src="https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=1200&auto=format&fit=crop&q=80"
                alt="Business meeting"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
        </div>

        <!-- Bottom gradient overlay for text -->
        <div class="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-black/70"></div>

        <!-- Text at bottom -->
        <div class="absolute bottom-0 left-0 right-0 p-12 text-white z-10">
          <h2 class="text-4xl font-bold mb-4">
            Attachment Management System
          </h2>
          <p class="text-xl font-light">
            DIGITIZING YOUR WORKFLOW.
          </p>
        </div>
      </div>

      <!-- Right Side - Reset Password Form -->
      <div class="flex-1 flex items-center justify-center p-8 bg-gray-50">
        <div class="w-full max-w-md">
          <!-- Value8 Logo -->
          <div class="text-center mb-8">
            <img
              src={~p"/images/logo.png"}
              alt="Value8 Logo"
              class="h-10 mx-auto mb-6"
            />
            <h3 class="text-3xl font-semibold text-gray-800 mb-2">Reset Password</h3>
            <p class="text-gray-600">Enter your email and we'll send you reset instructions</p>
          </div>

          <!-- Reset Form -->
          <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-8">
            <.form for={@form} phx-submit="send_reset" class="space-y-6">
              <!-- Email Field -->
              <div>
                <label for="user_email" class="block text-sm font-semibold text-gray-700 mb-2">
                  Employee Email
                </label>
                <input
                  id="user_email"
                  name="user[email]"
                  type="email"
                  autocomplete="email"
                  required
                  placeholder="your.email@company.com"
                  class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition text-gray-900"
                />
              </div>

              <!-- Submit Button -->
              <div>
                <button
                  type="submit"
                  class="w-full bg-indigo-600 text-white font-semibold py-3 px-4 rounded-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition"
                >
                  Send Reset Instructions
                </button>
              </div>

              <!-- Back to Login -->
              <div class="text-center">
                <.link
                  navigate={~p"/login"}
                  class="text-sm font-medium text-indigo-600 hover:text-indigo-700 transition"
                >
                  ← Back to Sign In
                </.link>
              </div>
            </.form>
          </div>

          <!-- Footer -->
          <div class="mt-8 text-center text-sm text-gray-600">
            <div class="flex items-center justify-center gap-2 mb-2">
              <span>Powered by</span>
              <img
                src={~p"/images/logo.png"}
                alt="Value8"
                class="h-5"
              />
            </div>
            <div class="flex items-center justify-center gap-4 text-gray-500">
              <a href="mailto:info@valuechainfactory.com" class="hover:text-gray-700 flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                </svg>
                info@valuechainfactory.com
              </a>
              <a href="tel:02079030025" class="hover:text-gray-700 flex items-center gap-1">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                </svg>
                020 7903025
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <style>
      .slide-container {
        position: relative;
        width: 100%;
        height: 100%;
        overflow: hidden;
      }

      .slide {
        position: absolute;
        inset: 0;
        opacity: 0;
        animation: slideShow 18s infinite;
      }

      /* First slide: show immediately */
      .slide:first-child {
        opacity: 1;
        animation-delay: 0s;
      }

      .slide:nth-child(2) { animation-delay: 6s; }
      .slide:nth-child(3) { animation-delay: 12s; }

      @keyframes slideShow {
        0%, 28% { opacity: 1; }
        33%, 61% { opacity: 1; }
        66%, 100% { opacity: 0; }
      }

      .slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        filter: brightness(0.85);
        animation: kenburns 18s ease-in-out infinite;
      }

      @keyframes kenburns {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.08); }
      }
    </style>
    """
  end

  def handle_event("send_reset", %{"user" => %{"email" => email}}, socket) do
    IO.inspect(email, label: "Sending reset email to")

    {:noreply,
     socket
     |> put_flash(:info, "If an account exists with that email, you will receive password reset instructions.")
     |> push_navigate(to: ~p"/login")}
  end
end
