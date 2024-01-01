use std::collections::VecDeque;
use std::io::Write;

use crossterm::{cursor, execute, terminal};

#[derive(Debug)]
pub struct Renderer<W> {
    is_first_render: bool,
    line_count: usize,
    prev_line_count: usize,
    stdout: W,
}

impl<W> Renderer<W> {
    pub fn new(writer: W) -> Self {
        Self {
            is_first_render: true,
            line_count: 0,
            prev_line_count: 0,
            stdout: writer,
        }
    }
}

impl<W> Renderer<W>
where
    W: Write,
{
    fn clear_ouput(&mut self) -> anyhow::Result<()> {
        if self.prev_line_count == 0 {
            return Ok(());
        }

        execute!(
            self.stdout,
            cursor::MoveToPreviousLine(self.prev_line_count as u16),
            terminal::Clear(terminal::ClearType::FromCursorDown)
        )?;

        Ok(())
    }

    pub fn clear_output_final(&mut self) -> anyhow::Result<()> {
        execute!(
            self.stdout,
            cursor::MoveToPreviousLine(self.prev_line_count as u16 + 1),
            terminal::Clear(terminal::ClearType::FromCursorDown)
        )?;

        Ok(())
    }

    pub fn render_queue(&mut self, queue: &VecDeque<String>) -> anyhow::Result<()> {
        self.line_count = queue.len();

        if self.is_first_render {
            self.is_first_render = false;
        } else {
            self.clear_ouput()?;
        }

        let width = match terminal::size() {
            Ok((w, _)) if w > 0 => w,
            _ => 100,
        };

        for line in queue {
            let mut l = line.clone();
            l.truncate(width as usize);
            writeln!(&mut self.stdout, "{l}")?;
        }

        self.prev_line_count = self.line_count;

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_renderer() {
        let mut stdout = Vec::new();
        let mut renderer = Renderer::new(&mut stdout);
        let mut queue: VecDeque<String> = VecDeque::with_capacity(5);

        let len = 100;
        let mut res = vec![];

        for i in 0..len {
            queue.push_back(format!("line {i}"));
            renderer.render_queue(&queue).unwrap();

            for j in 0..i {
                res.push(format!("line {j}\n"));
            }

            if i == len - 1 {
                res.push(format!("\u{1b}[{i}F\u{1b}[J"));
                for j in 0..len {
                    res.push(format!("line {j}\n"));
                }
            }

            if i > 0 && i < len - 1 {
                res.push(format!("\u{1b}[{i}F\u{1b}[J"));
            }
        }
        renderer.clear_output_final().unwrap();
        res.push(format!("\u{1b}[{}F\u{1b}[J", len + 1));

        assert_eq!(String::from_utf8(stdout).unwrap(), res.join("").to_string());
    }
}
