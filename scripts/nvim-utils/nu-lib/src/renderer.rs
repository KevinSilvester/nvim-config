use std::collections::VecDeque;

use crossterm::{cursor, execute, terminal};

#[derive(Debug)]
pub struct Renderer {
    is_first_render: bool,
    line_count: usize,
    prev_line_count: usize,
    stdout: std::io::Stdout,
}

impl Renderer {
    pub fn new() -> Self {
        Self {
            is_first_render: true,
            line_count: 0,
            prev_line_count: 0,
            stdout: std::io::stdout(),
        }
    }

    pub fn clear_ouput(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        if self.prev_line_count == 0 {
            return Ok(());
        }

        execute!(
            self.stdout,
            cursor::MoveToPreviousLine(self.prev_line_count as u16)
        )?;
        execute!(
            self.stdout,
            terminal::Clear(terminal::ClearType::FromCursorDown)
        )?;

        Ok(())
    }

    pub fn clear_output_final(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        execute!(
            self.stdout,
            cursor::MoveToPreviousLine(self.prev_line_count as u16 + 1)
        )?;
        execute!(
            self.stdout,
            terminal::Clear(terminal::ClearType::FromCursorDown)
        )?;

        Ok(())
    }

    pub fn render_queue(
        &mut self,
        queue: &VecDeque<String>,
    ) -> Result<(), Box<dyn std::error::Error>> {
        self.line_count = queue.len();

        if self.is_first_render {
            self.is_first_render = false;
        } else {
            self.clear_ouput()?;
        }

        for _line in queue {
            let width = match terminal::size() {
                Ok((w, _)) if w > 0 => w as usize,
                _ => 80,
            };
            let mut line = _line.clone();
            line.truncate(width);
            println!("{}", line);
        }

        self.prev_line_count = self.line_count;

        Ok(())
    }
}
