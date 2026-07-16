from src.main import main


def test_main(capsys) -> None:
    assert main() == 0
    assert capsys.readouterr().out == "Hello from your Python uv project!\n"
