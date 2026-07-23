from src.main import main


def test_main_prints_message_and_returns_success(capsys):
    assert main() == 0
    assert capsys.readouterr().out == "Hello from your Python uv project!\n"
